//
//  RefreshInterval.swift
//  fit-checker
//
//  Created by Josef Dolezal on 22/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

/// Possible intervals for background app refresh
enum RefreshInterval: Int {
    case twentyMinutes = 1200
    case hourly = 3600

    /// Convenience value name
    var interval: Double {
        return Double(self.rawValue)
    }
}
