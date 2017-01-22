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

    init(name: String) {
        self.name = name
    }


    static func !=(left:Lecture, right: Lecture) -> Bool {
        return !(left.name == right.name)
    }

}
