//
//  DetectedChangeType.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// Enum defining change type
///
/// - removed: item was removed in newe data
/// - added: item was added in new data
/// - modified: item was modified in new data
enum DetectedChangeType {
    case removed
    case added
    case modified
}

