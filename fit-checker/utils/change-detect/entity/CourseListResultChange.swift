//
//  CourseListResultChange.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// CourseListResultChange is child of ResultChange to keep track of possible
/// semester change.
class CourseListResultChange: ResultChange<CourseParsed> {

    var semesterChange: DetectedChange<String>?

    init(changes: [DetectedChange<CourseParsed>], sizeDifference: Int, semesterChange: DetectedChange<String>?) {
        super.init(changes: changes, sizeDifference: sizeDifference)
        self.semesterChange = semesterChange
    }


    /// Detects change by calling super method and checking semesterChange
    /// property.
    ///
    /// - Returns: true if change detected
    override func changeDetected() -> Bool {
        return super.changeDetected() || (semesterChange != nil)
    }
}
