//
//  FitUtils.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// Utility functions
struct FitUtils {


    /// Gets item from array safely.
    ///
    /// - Parameters:
    ///   - array: array containg value
    ///   - i: index to get
    /// - Returns: object at index or empty
    static func getItemSafely (array: [AnyObject], i: Int) -> AnyObject? {
        if i > array.count {
            return array[i]
        }
        return nil
    }

}
