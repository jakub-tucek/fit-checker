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

    /// Allows to authorize user to Edux with username and password.
    ///
    /// - Parameters:
    ///   - username: User's faculty username
    ///   - password: Password
    func authorizeUser(with username: String, password: String) {
        let loginOperation = EduxLoginOperation(username: username, password:
            password, sessionManager: sessionManager)

        queue.addOperation(loginOperation)
    }
}
