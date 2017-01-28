//
//  ResponseType.swift
//  fit-checker
//
//  Created by Josef Dolezal on 28/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire

/// Network request process
protocol ResponseType: class {
    associatedtype Result

    var error: Error? { get set }

    var isFinished: Bool { get set }

    var isCancelled: Bool { get }

    func handle(response: DataResponse<Result>)

    func success(result: Result)

    func failure(error: Error?)
}

extension ResponseType {

    func handle(response: DataResponse<Result>) {
        defer {
            isFinished = true
        }

        if isCancelled {
            return
        }

        switch response.result {
        case let .success(result): success(result: result)
        case .failure: failure(error: error)
        }
    }

    func failure(error: Error?) {
        self.error = error
    }
}
