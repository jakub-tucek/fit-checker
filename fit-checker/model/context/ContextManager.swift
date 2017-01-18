//
//  ContextManager.swift
//  fit-checker
//
//  Created by Josef Dolezal on 16/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift


/// Local database manager.
class ContextManager {
    /// Default database configuration
    private let configuration: Realm.Configuration = {
        var defaultConfiguration = Realm.Configuration.defaultConfiguration

        // Drop database if schema does not corresponds to stored data
        defaultConfiguration.deleteRealmIfMigrationNeeded = true

        return defaultConfiguration
    }()

    /// Create new database connection (must be created on each thread)
    ///
    /// - Returns: New realm instance
    func createContext() throws -> Realm {
        return try Realm(configuration: configuration)
    }
}
