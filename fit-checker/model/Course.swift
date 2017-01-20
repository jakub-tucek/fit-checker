//
//  Course.swift
//  fit-checker
//
//  Created by Josef Dolezal on 18/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

/// Edux course object
class Course: Object {

    //MARK: - Stored properties
    /// Unique course id
    dynamic var id = ""

    /// Course name
    dynamic var name = ""

    //MARK: - Initializers
    convenience init(id: String, name: String) {
        self.init()

        self.id = id
        self.name = name
    }

    //MARK: - Realm API
    override static func primaryKey() -> String? {
        return "id"
    }
}
