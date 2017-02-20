//
//  CourseParsed.swift
//  fit-checker
//
//  Created by Jakub Tucek on 14/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// CoursedParsed is simple object keeping information about parsed course.
class CourseParsed {

    let name: String

    /// True if course has classification page
    let classification: Bool

    init(name: String, classification: Bool = true) {
        self.name = name
        self.classification = classification
    }


    static func !=(left: CourseParsed, right: CourseParsed) -> Bool {
        return !((left.name == right.name) && (left.classification == right.classification))
    }

}
