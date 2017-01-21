//
//  ChangeDetecting.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// Protocol for detecting change.
protocol ChangeDetecting {

    associatedtype T
    associatedtype U


    /// Compares two inputs and returned result of type U that
    /// contains detected changes.
    ///
    /// - Parameters:
    ///   - oldvalue: old value of type T
    ///   - newValue: new value of type T
    /// - Returns: detected change
    func detect(oldvalue: T, newValue: T) -> U

}

