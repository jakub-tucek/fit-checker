//
//  LectureListChange.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// Simple entity for keeping changes.
/// Default constructor creates default state. Default state is that no change
/// was detected.
class ResultChange<T: AnyObject> {

    var changes: [DetectedChange<T>]

    var sizeDifference: Int

    init(changes: [DetectedChange<T>], sizeDifference: Int) {
        self.changes = changes
        self.sizeDifference = sizeDifference
    }



    /// Returns if change was detected by checking size of changes array.
    ///
    /// - Returns: true if change was detected
    func changeDetected() -> Bool {
        return changes.count != 0
    }


}
