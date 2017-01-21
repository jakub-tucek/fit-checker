//
//  LectureListChange.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// Simple entity for keeping changes in LectureList.
/// Default constructor creates default state. Default state is that no change
/// was detected.
class LectureListChange {


    /// Defines one lecture change.
    struct Change {
        let type: ChangeType
        let oldValue: Lecture
        let newValue: Lecture
    }

    let lectureChanges: [Change]

    var sizeDifference: Int?

    init() {
        self.lectureChanges = [Change]()
    }

    init (lectureChanges:[Change], sizeDifference: Int) {
        self.lectureChanges = lectureChanges
        self.sizeDifference = sizeDifference
    }
    
    
    
}
