//
//  ResponseType.swift
//  fit-checker
//
//  Created by Josef Dolezal on 28/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire

/// Common network request process. Makes abstraction on the top
/// of the most common implementation of response processing.
protocol ResponseType: class {
    /// Type of result from
    associatedtype Result

    /// Request error
    var error: Error? { get set }

    /// Indicates whether the request is finished
    var isFinished: Bool { get set }

    /// Indicates whether the request is canceled
    var isCancelled: Bool { get }

    /// Default response handler
    ///
    /// - Parameter response: Server response
    func handle(response: DataResponse<Result>)

    /// Success request handler
    ///
    /// - Parameter result: Sanitized data from server
    func success(result: Result)

    /// Failure request handler
    ///
    /// - Parameter error: Occured error if catched
    func failure(error: Error?)
}

// MARK: - ResponseType default implementation
extension ResponseType {

    func handle(response: DataResponse<Result>) {
        // Defer statement is called whenever this methods ends,
        // it is the last processed block of code called within method call.
        defer {
            isFinished = true
        }

        if isCancelled {
            return
        }

        // Check if request was valid or not
        switch response.result {
        case let .success(result):
            success(result: result)
        case .failure:
            failure(error: error)
        }
    }

    func failure(error: Error?) {
        self.error = error
    }
}
