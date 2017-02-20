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

    typealias Completion = (Void) -> ()

    /// Network session manager, keeps cookies and shit
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default

        return SessionManager(configuration: configuration)
    }()

    /// Network requests queue
    private let queue = OperationQueue()

    /// Database context manager
    private let contextManager: ContextManager

    init(contextManager: ContextManager) {
        self.contextManager = contextManager

        // This is safe because network controller is
        // weak property, so no reference cycle should occure
        let retrier = EduxRetrier(networkController: self)

        sessionManager.retrier = retrier
    }

    /// Allows to authorize user to Edux with username and password
    ///
    /// - Parameters:
    ///   - username: User's faculty username
    ///   - password: Password
    /// - Returns: User login promise
    @discardableResult
    func authorizeUser(with username: String,
                       password: String) -> OperationPromise<Void> {

        let promise = OperationPromise<Void>()
        let loginOperation = EduxLoginOperation(username: username, password:
            password, sessionManager: sessionManager)

        loginOperation.promise = promise
        queue.addOperation(loginOperation)

        return promise
    }

    /// Loads latest classification results for given course
    ///
    /// - Parameters:
    ///   - courseId: ID (name) of the course
    ///   - student: Student username
    func loadCourseClassification(courseId: String, student: String) {
        let courseOperation = ReadCourseClassificationOperation(courseId:
            courseId, student: student, sessionManager:
            sessionManager, contextManager: contextManager)

        queue.addOperation(courseOperation)
    }

    /// Loads latest classification for all given courses,
    /// ideal for background refresh or initial app load
    ///
    /// - Parameters:
    ///   - courses: Set of courses to be downloaded
    ///   - student: Student username
    /// - Returns: Courses classification promise
    func loadCoursesClasification(courses: [Course],
                                  student: String) -> OperationPromise<Void>{

        let operations = courses.map { course in
            return ReadCourseClassificationOperation(courseId:
                course.id, student: student, sessionManager:
                sessionManager, contextManager: contextManager)
        }
        let promise = OperationPromise<Void>()
        let completion = BlockOperation {
            // Check if all operations finished successfully
            let success = operations.reduce(true) { $0 && $1.error == nil }

            success ? promise.success() : promise.failure()
        }

        // Wait with completion until all operations are finished
        operations.forEach { completion.addDependency($0) }

        queue.addOperations(operations, waitUntilFinished: false)
        queue.addOperation(completion)

        return promise
    }

    /// Load current course list
    ///
    /// - Parameter completion: Completion callback
    func loadCourseList(completion: Completion? = nil) {
        let coursesList = ReadCourseListOperation(
            sessionManager: sessionManager,
            contextManager: contextManager)
        let completionOperation = BlockOperation() {
            completion?()
        }

        completionOperation.addDependency(coursesList)
        queue.addOperations([coursesList, completionOperation],
                            waitUntilFinished: false)
    }
}
