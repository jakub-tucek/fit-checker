//
//  ClassificationDetect.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// Detects changes in classification
class ClassificationDetect {

    /// Compares two inputs and returns ResultChange that
    /// contains detected changes.
    ///
    /// - Parameters:
    ///   - oldValue: old value of type ClassificationResult
    ///   - newValue: new value of type ClassificationResult
    /// - Returns: detected change
    func detect(oldValue: ClassificationResult, newValue: ClassificationResult)
                    -> ResultChange<ClassificationRow> {
        let sizeDiff = detectSizeDiff(oldValue: oldValue, newValue: newValue)
        let changes = detectValuesChange(oldValue: oldValue, newValue: newValue)

        return ResultChange<ClassificationRow>(
                changes: changes,
                sizeDifference: sizeDiff
        )

    }

    /// Returns size difference in parsed classification.
    ///
    /// - Parameters:
    ///   - oldValue: old value of ClassificationResult
    ///   - newValue: new value of ClassificationResult
    /// - Returns: size difference
    private func detectSizeDiff(oldValue: ClassificationResult, newValue: ClassificationResult) -> Int {
        return countTotalRows(value: newValue) - countTotalRows(value: oldValue)
    }

    private func detectValuesChange(oldValue: ClassificationResult, newValue: ClassificationResult)
                    -> [Change<ClassificationRow>] {
        let oldRows = getAllRows(value: oldValue)
        let newRows = getAllRows(value: newValue)
        var changes = [Change<ClassificationRow>]()

        var oldIndex = 0
        var newIndex = 0

        while oldIndex < oldRows.count || newIndex < newRows.count {
            let oldItem = ArrayUtils<ClassificationRow>.getItemSafely(array: oldRows, i: oldIndex)
            let newItem = ArrayUtils<ClassificationRow>.getItemSafely(array: newRows, i: newIndex)

            let change = detectValueChange(oldItem: oldItem, newItem: newItem)
            if let change = change {
                changes.append(change)
            }

            oldIndex += 1
            newIndex += 1
        }

        return changes

    }



    /// Finds all row in all tables
    ///
    /// - Parameter value: ClassificaitonResult containg array on tables
    /// - Returns: array of all rows
    private func getAllRows(value: ClassificationResult) -> [ClassificationRow] {
        return value.tables
                .flatMap {
                    $0.rows
                }
    }

    private func detectValueChange(oldItem: ClassificationRow?, newItem: ClassificationRow?)
                    -> Change<ClassificationRow>? {
        var type: ChangeType?

        type = (oldItem == nil ? ChangeType.added : nil)

        type = (newItem == nil ? ChangeType.removed : type)

        if let old = oldItem, let new = newItem {
            if (old.name != new.name || old.value != new.value) {
                type = ChangeType.modified
            }
        }

        if let type = type {
            return Change<ClassificationRow>(
                    type: type,
                    oldValue: oldItem,
                    newValue: newItem
            )
        }
        return nil
    }


    /// Counts total rows with reduce
    ///
    /// - Parameter value: ClassificationResult object
    /// - Returns: total row count
    private func countTotalRows(value: ClassificationResult) -> Int {
        return value.tables.reduce(0) {
            $0 + $1.rows.count
        }
    }
}
