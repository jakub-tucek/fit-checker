//
//  Lecture.swift
//  fit-checker
//
//  Created by Jakub Tucek on 14/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// Lecture is simple object keeping information about parsed lecture.
class Lecture {

    let name: String

    /// True if lecture has classification page
    let classification: Bool

    init(name: String, classification: Bool = true) {
        self.name = name
        self.classification = classification
    }


    static func !=(left:Lecture, right: Lecture) -> Bool {
        return !(left.name == right.name)
    }

}
