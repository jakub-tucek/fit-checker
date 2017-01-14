//
//  BaseOperation.swift
//  fit-checker
//
//  Created by Josef Dolezal on 14/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire

class BaseOperation: Operation {
    /// Holds error when occured, nil otherwise
    var error: Error? {
        didSet {
            // Print the error if occures
            if let error = error {
                print("\(classForCoder): \(error)")
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
