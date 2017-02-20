//
//  Colors.swift
//  fit-checker
//
//  Created by Josef Dolezal on 07/02/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import UIKit

// MARK: - FIT Checker common colors
extension UIColor {

    /// Namespace for colors
    struct CVUT {
        /// Default CVUT blue
        static let blue = UIColor(red: 0.0000, green: 0.5059,
                                  blue: 0.8510, alpha: 1.0)

        /// Light gray (user for separators, etc)
        static let lightGray = UIColor(red: 0.9020, green: 0.9020,
                                       blue: 0.9020, alpha: 1.0)

        /// Active success button background color
        static let activeButton = UIColor(red:0.0549, green: 0.3843,
                                          blue: 0.6118, alpha: 1.0)

        /// Disabled success button background color
        static let disabledButton = UIColor(red:0.0824, green: 0.4706,
                                          blue: 0.7333, alpha: 1.0)
    }
}
