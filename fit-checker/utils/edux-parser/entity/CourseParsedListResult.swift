//
//  CourseParsedListResult.swift
//  fit-checker
//
//  Created by Jakub Tucek on 14/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// CourseParsedListResult is object keeping info about parsing courses.
class CourseParsedListResult {


    /// Timestamp when result was created
    let timestamp = Date()

    var semesterInfo: String = ""

    var courses = [CourseParsed]()

    init() {
        //empty
    }
    init(courses: [CourseParsed]) {
        self.courses = courses
    }


}
