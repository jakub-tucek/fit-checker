//
//  BaseOperation.swift
//  fit-checker
//
//  Created by Josef Dolezal on 14/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire


/// Base class for network operations.
class BaseOperation: Operation {
    /// Holds error when occured, nil otherwise
    var error: Error? {
        didSet {
            // Print the error if occures
            if let error = error {
                Logger.shared.error("\(classForCoder): \(error)")
            }
        }
    }

    /// Injected request manager
    var sessionManager: SessionManager

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager

        super.init()
    }

    /// Indicates wheter async operation is finished
    var internalIsFinished = false
    override var isFinished: Bool {
        get {
            return internalIsFinished
        } set {
            // Enable KVO on isFinished to notify queue if value is changed
            willChangeValue(forKey: "isFinished")
            internalIsFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
}

/// Network operation promise, allows Operatation creator
/// to set custom callbacks.
class OperationPromise<T> {
    /// Success callback
    var success: (T) -> Void = { _ in }

    /// Failure callback
    var failure: () -> Void = {}
}
