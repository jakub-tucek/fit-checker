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

    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default

        return SessionManager(configuration: configuration)
    }()

    private let queue = OperationQueue()

    func authorizeUser(with username: String, password: String) {
        
    }
}
