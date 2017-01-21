//
//  Keechain.swift
//  fit-checker
//
//  Created by Josef Dolezal on 17/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import KeychainAccess


/// Conviniet wrapper for KeychainAccess framework.
class Keechain {

    typealias Account = (username: String, password: String)

    /// Available services storable in keychain
    enum Service {
        case edux

        /// Service identifier
        var identifier: String {
            switch self {
            case .edux: return "cz.edux"
            }
        }

        /// Protocol for internet service
        var protocolType: ProtocolType {
            switch self {
            case .edux: return .https
            }
        }
    }

    /// Common keys constants
    struct Keys {
        static let username = "username"
        static let password = "password"
    }

    /// Namespace for user data
    private let service: Service

    init(service: Service) {
        self.service = service
    }

    /// Loads user account for current service
    ///
    /// - Returns: Stored account or nil if not presented
    func getAccount() -> Account? {
        guard
                let username = getValue(for: Keys.username),
                let password = getValue(for: Keys.password) else {
            return nil
        }

        return (username, password)
    }

    /// Convenient method for saving user account
    ///
    /// - Parameters:
    ///   - username: Username for current user
    ///   - password: Password associated with username
    func saveAccount(username: String, password: String) {
        set(value: username, for: Keys.username)
        set(value: password, for: Keys.password)
    }

    func deleteAccount() {
        delete(key: Keys.username)
        delete(key: Keys.password)
    }

    /// Saves value for given key in current service
    ///
    /// - Parameters:
    ///   - value: Value to be stored
    ///   - key: Key for stored value
    private func set(value: String, for key: String) {
        let keychain = Keychain(service: service)

        try? keychain.set(value, key: key)
    }

    /// Deletes encrypted value for given key
    ///
    /// - Parameter key: Key of value which will be removed
    private func delete(key: String) {
        let keychain = Keychain(service: service)

        try? keychain.remove(key)
    }

    /// Reads encrypted user data from keychain
    ///
    /// - Parameter key: Keychain
    /// - Returns: Decrypted data for given key | nil if not presented or value
    ///            is corrupted
    private func getValue(for key: String) -> String? {
        let keychain = Keychain(service: service)

        do {
            return try keychain.getString(key)
        } catch {
            return nil
        }
    }
}
