//
//  Notifications+Extension.swift
//  fit-checker
//
//  Created by Josef Dolezal on 17/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

extension Notification.Name {
    /// Posted when user login stated changed (login/logout/invalid credentials)
    static let FCLoginStateChanged = Notification.Name("FCLoginStateChanged")
}
