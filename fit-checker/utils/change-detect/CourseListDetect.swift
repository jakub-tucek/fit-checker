//
//  File.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// Detects changes in course list
class CourseListDetect {

    /// Compares two inputs and returns CourseListResultChange that
    /// contains detected changes.
    ///
    /// - Parameters:
    ///   - oldValue: old value of type CourseParsedListResult
    ///   - newValue: new value of type CourseParsedListResult
    /// - Returns: detected change
    func detect(oldValue: CourseParsedListResult, newValue: CourseParsedListResult)
                    -> CourseListResultChange {

        let sizeDiff = detectSizeDiff(oldValue: oldValue, newValue: newValue)
        let semesterChange = detectSemesterChange(oldValue: oldValue, newValue: newValue)
        let valuesChange = detectValuesChange(oldValue: oldValue, newValue: newValue)

        return CourseListResultChange(
                changes: valuesChange,
                sizeDifference: sizeDiff,
                semesterChange: semesterChange
        )
    }

    /// Returns size difference in parsed courses
    ///
    /// - Parameters:
    ///   - oldValue: old value of CourseParsedListResult
    ///   - newValue: new value of CourseParsedListResult
    /// - Returns: size difference
    private func detectSizeDiff(oldValue: CourseParsedListResult, newValue: CourseParsedListResult) -> Int {
        return newValue.courses.count - oldValue.courses.count
    }



    /// Detects semester label change.
    ///
    /// - Parameters:
    ///   - oldValue: old value of CourseParsedListResult
    ///   - newValue: new value of CourseParsedListResult
    /// - Returns: Change entity or empty if no change detected
    private func detectSemesterChange(oldValue: CourseParsedListResult, newValue: CourseParsedListResult)
                    -> DetectedChange<String>? {

        guard oldValue.semesterInfo != newValue.semesterInfo else {
            return nil
        }
        var type: DetectedChangeType

        if oldValue.semesterInfo.isEmpty {
            type = DetectedChangeType.added
        } else if newValue.semesterInfo.isEmpty {
            type = DetectedChangeType.removed
        } else {
            type = DetectedChangeType.modified
        }

        return DetectedChange(
                type: type,
                oldValue: oldValue.semesterInfo,
                newValue: newValue.semesterInfo
        )
    }


    /// Iterates over all values and returns changes for each index.
    ///
    /// - Parameters:
    ///   - oldValue: old value of CourseParsedListResult
    ///   - newValue: new value of CourseParsedListResult
    /// - Returns: Change entity array or empty array if no change detected
    private func detectValuesChange(oldValue: CourseParsedListResult, newValue: CourseParsedListResult)
                    -> [DetectedChange<CourseParsed>] {
        var changes = [DetectedChange<CourseParsed>]()
        let oldLectures = oldValue.courses
        let newLectures = newValue.courses

        var oldIndex = 0
        var newIndex = 0

        while oldIndex < oldLectures.count || newIndex < newLectures.count {
            let oldItem = ArrayUtils<CourseParsed>.getItemSafely(array: oldLectures, i: oldIndex)
            let newItem = ArrayUtils<CourseParsed>.getItemSafely(array: newLectures, i: newIndex)

            let change = detectValueChange(oldItem: oldItem, newItem: newItem)
            if let change = change {
                changes.append(change)
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
    private func detectValueChange(oldItem: CourseParsed?, newItem: CourseParsed?) -> DetectedChange<CourseParsed>? {
        var type: DetectedChangeType?

        type = (oldItem == nil ? DetectedChangeType.added : nil)

        type = (newItem == nil ? DetectedChangeType.removed : type)


        if let old = oldItem, let new = newItem, old != new {
            type = DetectedChangeType.modified
        }

        if let type = type {
            return DetectedChange<CourseParsed>(
                    type: type,
                    oldValue: oldItem,
                    newValue: newItem
            )
        }
        return nil
    }


}
