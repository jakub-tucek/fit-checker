//
//  VoidResponseType.swift
//  fit-checker
//
//  Created by Josef Dolezal on 29/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire

protocol VoidResponseType: ResponseType {
    typealias Result = Void
}

extension VoidResponseType {
    func handle(response: DataResponse<Void>) {
        // Defer statement is called whenever this methods ends,
        // it is the last processed block of code called within method call.
        defer {
            isFinished = true
        }

        if isCancelled {
            return
        }

        switch response.error == nil {
        case true:
            success(result: ())
        case false:
            failure(error: response.error)
        }
    }
}
