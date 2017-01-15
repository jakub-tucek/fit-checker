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

    init(courseId: String, student: String, sessionManager: SessionManager) {
        self.courseId = courseId
        self.student = student

        super.init(sessionManager: sessionManager)
    }

    override func start() {
        _ = sessionManager.request(EduxRouter.courseClassification(
            courseId: courseId, student: student))
            .validate().responseString(
                completionHandler: handle)
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
            print(html)
        case .failure: self.error = error
        }
    }
}
