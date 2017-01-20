//
//  LogoutOperation.swift
//  fit-checker
//
//  Created by Josef Dolezal on 20/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// Taks which clears all user data,
/// removes stored credentials and then notifies subscribers
class LogoutOperation: Operation {

    /// Database context manager
    private let contextManager: ContextManager

    init(contextManager: ContextManager) {
        self.contextManager = contextManager
    }

    override func start() {
        defer {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .FCLoginStateChanged,
                                                object: nil)
            }
        }

        do {
            let realm = try contextManager.createContext()
            let keychain = Keechain(service: .edux)

            keychain.deleteAccount()

            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Logout error: \(error)")
        }
    }
}
