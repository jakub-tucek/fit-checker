//
//  KeychainAccess+Keechain.swift
//  fit-checker
//
//  Created by Josef Dolezal on 20/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import KeychainAccess


extension Keychain {
    /// Allows to initialize Keychain with custom service
    ///
    /// - Parameter service: Remote service
    convenience init(service: Keechain.Service) {
        self.init(server: service.identifier,
                protocolType: service.protocolType)
    }
}
