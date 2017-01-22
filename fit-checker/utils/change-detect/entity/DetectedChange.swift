//
//  DetectedChange.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// Generic struct for keeping detected change.
struct DetectedChange<T> {
    let type: ChangeType
    let oldValue: T?
    let newValue: T?
}
