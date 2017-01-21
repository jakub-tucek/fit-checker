//
//  Change.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// Generic change struct.
struct Change<T> {
    let type: ChangeType
    let oldValue: T
    let newValue: T
}
