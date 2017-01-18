//
//  NetworkController.swift
//  fit-checker
//
//  Created by Josef Dolezal on 13/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire


/// Represents networking layer, handles all remote requests.
/// As Edux credentials are stored in cookies, you have to
/// recycle (inject) instance to keep request authorized after login.
class NetworkController {

    /// Network session manager, keeps cookies and shit
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default

        return SessionManager(configuration: configuration)
    }()

    /// Network requests queue
    private let queue = OperationQueue()

    /// Allows to authorize user to Edux with username and password
    ///
    /// - Parameters:
    ///   - username: User's faculty username
    ///   - password: Password
    func authorizeUser(with username: String,
                       password: String) -> OperationPromise<Void> {

        let promise = OperationPromise<Void>()
        let loginOperation = EduxLoginOperation(username: username, password:
            password, sessionManager: sessionManager)

        loginOperation.promise = promise
        queue.addOperation(loginOperation)

        return promise
    }

    /// Loads latest classification results for given subject
    ///
    /// - Parameters:
    ///   - courseId: ID (name) of the course
    ///   - student: Student username
    func loadCourseClassification(courseId: String, student: String) {
        let courseOperation = ReadCourseClassificationOperation(courseId:
            courseId, student: student, sessionManager: sessionManager)

        queue.addOperation(courseOperation)
    }
}
