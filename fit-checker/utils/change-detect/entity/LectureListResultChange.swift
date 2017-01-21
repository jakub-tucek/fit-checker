//
//  LectureListResultChange.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// LectureListResultChange is child of ResultChange to keep track of possible
/// semester change.
class LectureListResultChange: ResultChange<Lecture> {

    var semesterChange: Change<String>?

    init(changes: [Change<Lecture>], sizeDifference: Int, semesterChange: Change<String>?) {
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
