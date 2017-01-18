//
//  EduxLoginOperation.swift
//  fit-checker
//
//  Created by Josef Dolezal on 13/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire

/// Handles user login to Edux.
class EduxLoginOperation: BaseOperation {

    /// Completion promise
    var promise: OperationPromise<Void>?

    /// Parameters which will be presented in URL query string
    private let queryParameters: Parameters

    /// Data which will be contained in request body
    private let bodyParameters: Parameters

    /// Current user name
    private let username: String

    /// Current user password
    private let password: String

    /// Element which determines whether the user is logged in or not
    private static let loginIdentifier = "Odhlásit se."

    init(username: String, password: String, sessionManager: SessionManager) {

        queryParameters = ["do": "login"]

        bodyParameters = [
            "id": "start",
            "do": "login",
            "authnProvider": 1,
            "u": username,
            "p": password,
        ]

        self.username = username
        self.password = password

        super.init(sessionManager: sessionManager)
    }

    override func start() {
        _ = sessionManager.request(EduxRouter.login(query: queryParameters,
                                                    body: bodyParameters))
            .validate().validate(EduxLoginOperation.validateLogin)
            .response(completionHandler: handle)
    }

    /// Checks whether user login was successfull.
    ///
    /// - Parameters:
    ///   - request: Original URL request
    ///   - response: Server response
    ///   - data: Response data
    /// - Returns: Failure if login was not successfull, success otherwise
    static func validateLogin(request: URLRequest?,
                              response: HTTPURLResponse, data: Data?)
        -> Request.ValidationResult {

            guard
                let data = data,
                let html = String(data: data, encoding: .utf8) else {

                return .failure(EduxLoginOperationError.generalError)
            }

            return html.contains(EduxLoginOperation.loginIdentifier)
                ? .failure(EduxLoginOperationError.badCredentials)
                : .success
    }

    /// Finishes operation based on validation results.
    ///
    /// - Parameter response: Server response
    func handle(response: DefaultDataResponse) {
        defer {
            isFinished = true
        }

        if isCancelled {
            return
        }

        switch response.error == nil {
        case true:
            let keychain = Keechain(service: .edux)

            keychain.saveAccount(username: username, password: password)
            promise?.success()
        case false:
            self.error = response.error
            promise?.failure()
        }
    }
}

/// Possible Edux login error.
///
/// - generalError: Occures when server response is not valid html or has bad response code
/// - badCredentials: Thrown when user credentials are not valid
enum EduxLoginOperationError: Error {
    case generalError
    case badCredentials
}
