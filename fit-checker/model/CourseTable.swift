//
//  CourseParsedTable.swift
//  fit-checker
//
//  Created by Josef Dolezal on 21/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift


/// Groups classification records by table.
/// There could be more tables for course (tests, assignments, ...)
/// and all of them may have multiple records (assignment 1, assignment 2, ...)
class CourseTable: Object {

    //MARK: - Stored properties

    /// Name of table
    dynamic var name: String?

    /// Associated course identifier
    dynamic var courseId: String = ""

    // All rows in table
    let classification = List<ClassificationRecord>()

    //MARK: - Initializers

    convenience init(name: String? = nil,
                     courseId: String,
                     classification: [ClassificationRecord]) {
        self.init()

        self.name = name
        self.courseId = courseId
        self.classification.append(objectsIn: classification)
    }
}
