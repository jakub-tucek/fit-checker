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

    /// Indicates wheter classification for this course is available
    dynamic var classificationAvailable = false

    //MARK: - Initializers
    convenience init(id: String, name: String, classificationAvailable: Bool) {
        self.init()

        self.id = id
        self.name = name
        self.classificationAvailable = classificationAvailable
    }

    //MARK: - Realm API
    override static func primaryKey() -> String? {
        return "id"
    }
}
