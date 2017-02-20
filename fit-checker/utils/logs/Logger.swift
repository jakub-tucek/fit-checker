//
//  Logger.swift
//  fit-checker
//
//  Created by Josef Dolezal on 21/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import SwiftyBeaver

/// Simple wrapper for SwiftyBeaver framework. Provides preconfigured log
/// class for console logging.
class Logger {

    /// Preconfigured shared instance for SwiftyBeaver
    static let shared: SwiftyBeaver.Type = {
        let log = SwiftyBeaver.self
        let console = ConsoleDestination()

        log.addDestination(console)

        return log
    }()

    /// Singleton private initializer disables
    /// to create new instances
    private init() { }
}
