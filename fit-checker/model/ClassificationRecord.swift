//
//  ClassificationRecord.swift
//  fit-checker
//
//  Created by Josef Dolezal on 21/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift


/// Represents one row in course classification table.
/// Each course table may have multiple classification records.
class ClassificationRecord: Object {

    //MARK: - Stored properties

    /// Classification record label/description
    var name: String = ""

    /// Earned score for exercise (test, assignment, ...)
    var score: String = ""

    //MARK: - Initializers

    convenience init(name: String, score: String) {
        self.init()

        self.name = name
        self.score = score
    }
}
