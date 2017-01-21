//
//  File.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// Detects changes in lecture list
class LectureListDetect {

    /// Compares two inputs and returns LectureListResultChange that
    /// contains detected changes.
    ///
    /// - Parameters:
    ///   - oldvalue: old value of type LectureListResult
    ///   - newValue: new value of type LectureListResult
    /// - Returns: detected change
    func detect(oldValue: LectureListResult, newValue: LectureListResult)
                    -> LectureListResultChange {

        let sizeDiff = detectSizeDiff(oldValue: oldValue, newValue: newValue)
        let semesterChange = detectSemesterChange(oldValue: oldValue, newValue: newValue)
        let valuesChange = detectValuesChange(oldValue: oldValue, newValue: newValue)

        return LectureListResultChange(
                changes: valuesChange,
                sizeDifference: sizeDiff,
                semesterChange: semesterChange
        )
    }

    /// Returns size difference in parsed lectures
    ///
    /// - Parameters:
    ///   - oldValue: old value of LectureListResult
    ///   - newValue: new value of LectureListResult
    /// - Returns: size difference
    func detectSizeDiff(oldValue: LectureListResult, newValue: LectureListResult) -> Int {
        return newValue.lectures.count - oldValue.lectures.count
    }



    /// Detects semester label change.
    ///
    /// - Parameters:
    ///   - oldValue: old value of LectureListResult
    ///   - newValue: new value of LectureListResult
    /// - Returns: Change entity or empty if no change detected
    func detectSemesterChange(oldValue: LectureListResult, newValue: LectureListResult)
                    -> Change<String>? {
        if oldValue.semesterInfo != newValue.semesterInfo {
            var type: ChangeType

            if oldValue.semesterInfo.isEmpty {
                type = ChangeType.added
            } else if newValue.semesterInfo.isEmpty {
                type = ChangeType.removed
            } else {
                type = ChangeType.modified
            }

            return Change(
                    type: type,
                    oldValue: oldValue.semesterInfo,
                    newValue: newValue.semesterInfo
            )
        }
        return nil
    }


    /// Iterates over all values and returns changes for each index.
    ///
    /// - Parameters:
    ///   - oldValue: old value of LectureListResult
    ///   - newValue: new value of LectureListResult
    /// - Returns: Change entity array or empty array if no change detected
    func detectValuesChange(oldValue: LectureListResult, newValue: LectureListResult)
                    -> [Change<Lecture>] {
        var changes = [Change<Lecture>]()
        let oldLectures = oldValue.lectures
        let newLectures = newValue.lectures

        var oldIndex = 0
        var newIndex = 0

        while oldIndex < oldLectures.count || newIndex < newLectures.count {
            let oldItem = ArrayUtils<Lecture>.getItemSafely(array: oldLectures, i: oldIndex)
            let newItem = ArrayUtils<Lecture>.getItemSafely(array: newLectures, i: newIndex)

            let change = detectValueChange(oldItem: oldItem, newItem: newItem)
            if let changeUnwrapped = change {
                changes.append(changeUnwrapped)
            }

            oldIndex += 1
            newIndex += 1
        }

        return changes
    }



    /// Detects if change occured. By checking if one of items is not 
    /// missing. If both are equal, then their name is checked.
    ///
    /// - Parameters:
    ///   - oldValue: old value of Lecture
    ///   - newValue: new value of Lecture
    /// - Returns: Change entity or empty if no change detected
    func detectValueChange(oldItem: Lecture?, newItem: Lecture?) -> Change<Lecture>? {
        var type: ChangeType?

        type = (oldItem == nil ? ChangeType.added : nil)

        type = (newItem == nil ? ChangeType.removed : type)

        if let old = oldItem, let new = newItem {
            type = (old.name != new.name ? ChangeType.modified : type)
        }

        if let type = type {
            return Change<Lecture>(
                    type: type,
                    oldValue: oldItem,
                    newValue: newItem
            )
        }
        return nil
    }


}
