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
class EduxLoginOperation: BaseOperation, ResponseType {

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
            .validate().validate(EduxValidators.validCredentials)
            .responseVoid(completionHandler: handle)
    }

    /// Authorization success callback
    ///
    /// - Parameter result: Downloaded HTML
    func success(result: Void) {
        let keychain = Keechain(service: .edux)

        keychain.saveAccount(username: username, password: password)
        promise?.success()
    }
}
