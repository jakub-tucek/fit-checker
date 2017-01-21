//
//  ReadCourseClassificationOperation.swift
//  fit-checker
//
//  Created by Josef Dolezal on 13/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire


/// Downloads HTML page for course classification.
class ReadCourseClassificationOperation: BaseOperation {

    /// Edux course id
    private let courseId: String

    /// Student username
    private let student: String

    /// Database context manager
    private let contextManager: ContextManager

    init(courseId: String, student: String, sessionManager: SessionManager,
         contextManager: ContextManager) {

        self.courseId = courseId
        self.student = student
        self.contextManager = contextManager

        super.init(sessionManager: sessionManager)
    }

    override func start() {
        _ = sessionManager.request(EduxRouter.courseClassification(
            courseId: courseId, student: student))
            .validate()
            .validate(EduxValidators.authorizedHTML)
            .responseString(completionHandler: handle)
    }

    /// Handle HTML response
    ///
    /// - Parameter response: Server response
    func handle(response: DataResponse<String>) {
        defer {
            isFinished = true
        }

        if isCancelled {
            return
        }

        switch response.result {
        case let .success(html):
            let parser = ClassificationParser()
            let tables = parser.parseEdux(html: html).tables.map { table -> CourseTable in
                let classification = table.rows.map({ row in
                    return ClassificationRecord(name: row.name, score: row.value)
                })

                return CourseTable(name: table.name, courseId: courseId,
                                   classification: classification)
            }

            do {
                let realm = try contextManager.createContext()
                let oldTables = realm.objects(CourseTable.self)
                    .filter("courseId = %@", courseId)

                try realm.write {
                    realm.delete(oldTables)
                    realm.add(tables)
                }
            } catch {
                self.error = error
            }
        case .failure: self.error = error
        }
    }
}
