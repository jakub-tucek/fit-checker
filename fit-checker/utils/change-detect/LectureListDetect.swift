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
    ///   - oldValue: old value of type LectureListResult
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
    private func detectSizeDiff(oldValue: LectureListResult, newValue: LectureListResult) -> Int {
        return newValue.lectures.count - oldValue.lectures.count
    }



    /// Detects semester label change.
    ///
    /// - Parameters:
    ///   - oldValue: old value of LectureListResult
    ///   - newValue: new value of LectureListResult
    /// - Returns: Change entity or empty if no change detected
    private func detectSemesterChange(oldValue: LectureListResult, newValue: LectureListResult)
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
    ///   - oldValue: old value of LectureListResult
    ///   - newValue: new value of LectureListResult
    /// - Returns: Change entity array or empty array if no change detected
    private func detectValuesChange(oldValue: LectureListResult, newValue: LectureListResult)
                    -> [DetectedChange<Lecture>] {
        var changes = [DetectedChange<Lecture>]()
        let oldLectures = oldValue.lectures
        let newLectures = newValue.lectures

        var oldIndex = 0
        var newIndex = 0

        while oldIndex < oldLectures.count || newIndex < newLectures.count {
            let oldItem = ArrayUtils<Lecture>.getItemSafely(array: oldLectures, i: oldIndex)
            let newItem = ArrayUtils<Lecture>.getItemSafely(array: newLectures, i: newIndex)

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
    private func detectValueChange(oldItem: Lecture?, newItem: Lecture?) -> DetectedChange<Lecture>? {
        var type: DetectedChangeType?

        type = (oldItem == nil ? DetectedChangeType.added : nil)

        type = (newItem == nil ? DetectedChangeType.removed : type)


        if let old = oldItem, let new = newItem, old != new {
            type = DetectedChangeType.modified
        }

        if let type = type {
            return DetectedChange<Lecture>(
                    type: type,
                    oldValue: oldItem,
                    newValue: newItem
            )
        }
        return nil
    }


}
