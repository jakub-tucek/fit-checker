//
//  EduxRetrier.swift
//  fit-checker
//
//  Created by Josef Dolezal on 20/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire


/// Allows to retry failed operations. If operation failed because of
/// missing cookies (uh, authorization) retrier tryes to login
/// user with stored credential and if it's successfull, calls original
/// request again.
class EduxRetrier: RequestRetrier {

    /// Network request manager -
    private weak var networkController: NetworkController?

    /// Thread safe token refreshning indicator
    private var isRefreshing = false

    /// Synchronizing queue
    private let accessQueue = DispatchQueue(label: "EduxRetrier")

    init(networkController: NetworkController) {
        self.networkController = networkController
    }

    /// Determines wheter
    ///
    /// - Parameters:
    ///   - manager: Requests session manager
    ///   - request: Failed request
    ///   - error: Request error
    ///   - completion: Retry decision
    public func should(_ manager: SessionManager, retry request: Request,
                       with error: Error,
                       completion: @escaping RequestRetryCompletion) {

        print("Ooops, request failed")

        // Run validation on serial queue
        accessQueue.async { [weak self] in
            let keychain = Keechain(service: .edux)

            // Retry only on recognized errors
            guard
                case EduxValidators.ValidationError.badCredentials = error else {

                print("Unrecognized error, not retrying.")
                completion(false, 0.0)
                return
            }

            guard
                self?.isRefreshing == false,
                let networkController = self?.networkController,
                let (username, password) = keychain.getAccount() else { return }


            print("Retrying request")

            self?.isRefreshing = true

            let promise = networkController.authorizeUser(with: username,
                                                          password: password)

            // Try to authorize user
            promise.success = {
                completion(true, 0.0)
            }

            promise.failure = {
                completion(false, 0.0)
            }

            self?.isRefreshing = false
        }
    }
}
