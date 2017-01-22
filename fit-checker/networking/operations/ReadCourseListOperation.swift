//
//  ReadCourseListOperation.swift
//  fit-checker
//
//  Created by Josef Dolezal on 13/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire

/// Read user course list request operation.
class ReadCourseListOperation: BaseOperation {

    /// Parameters presented in request query string
    private static let query: Parameters = ["dashboard_current_lang": "cs"]

    /// Parameters presented in request body
    private static let body: Parameters = [
        "call": "dashboard_widget_update",
        "widget_real_id": "w_actual_courses_fit",
        "widget_max": 0,
        "lazy": 1
    ]

    /// Database context manager
    private let contextManager: ContextManager

    init(sessionManager: SessionManager, contextManager: ContextManager) {
        self.contextManager = contextManager

        super.init(sessionManager: sessionManager)
    }

    override func start() {
        _ = sessionManager.request(EduxRouter.courseList(
            query: ReadCourseListOperation.query,
            body: ReadCourseListOperation.body)
            )
            .validate()
            .validate(EduxValidators.authorizedJSON)
            .responseJSON(completionHandler: handle)
    }

    /// Handle server response data and parse course list
    ///
    /// - Parameter response: Remote server response
    func handle(response: DataResponse<Any>) {
        defer {
            isFinished = true
        }

        if isCancelled {
            return
        }

        switch response.result {
        case let .success(json):
            guard let json = json as? [String: Any?] else { return }

            let parser = CourseListParser()
            let parsedCourses = parser.parse(json: json)
            let courses = parsedCourses.courses.map({ course -> Course in
                return Course(id: lecture.name, name: lecture.name,
                              classificationAvailable: lecture.classification)
            })

            do {
                let realm = try contextManager.createContext()

                try realm.write() {
                    realm.add(courses, update: true)
                }
            } catch {
                self.error = error
            }

        case .failure:
            self.error = error
        }
    }

}
