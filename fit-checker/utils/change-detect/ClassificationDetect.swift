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


    /// Iterates over each table and checks differences. That makes each table
    /// check independent.
    ///
    /// - Parameters:
    ///   - oldValue: ClassificationResult
    ///   - newValue: ClassificationResult
    /// - Returns: changes
    private func detectValuesChange(oldValue: ClassificationResult, newValue: ClassificationResult)
                    -> [DetectedChange<ClassificationRow>] {
        let oldTables = oldValue.tables
        let newTables = newValue.tables
        var changes = [DetectedChange<ClassificationRow>]()

        var oldIndex = 0
        var newIndex = 0

        while oldIndex < oldTables.count || newIndex < newTables.count {
            let oldTable = ArrayUtils<ClassificationTable>.getItemSafely(array: oldTables, i: oldIndex)
            let newTable = ArrayUtils<ClassificationTable>.getItemSafely(array: newTables, i: newIndex)

            let tableChanges = detectChangeForTable(oldTable: oldTable, newTable: newTable)

            changes.append(contentsOf: tableChanges)

            oldIndex += 1
            newIndex += 1
        }

        return changes
    }


    /// Iterates over rows in tables and detect changes there.
    ///
    /// - Parameters:
    ///   - oldTable: ClassificationTable?
    ///   - newTable: ClassificationTable?
    /// - Returns: changes
    private func detectChangeForTable(oldTable: ClassificationTable?, newTable: ClassificationTable?)
                    -> [DetectedChange<ClassificationRow>] {
        let oldRows = getRowsSafely(table: oldTable)
        let newRows = getRowsSafely(table: newTable)
        var tableChanges = [DetectedChange<ClassificationRow>]()

        var oldRowIndex = 0
        var newRowIndex = 0

        while oldRowIndex < oldRows.count || newRowIndex < newRows.count {
            let oldRow = ArrayUtils<ClassificationRow>.getItemSafely(array: oldRows, i: oldRowIndex)
            let newRow = ArrayUtils<ClassificationRow>.getItemSafely(array: newRows, i: newRowIndex)

            let change = detectValueChange(oldItem: oldRow, newItem: newRow)
            if let change = change {
                tableChanges.append(change)
            }

            oldRowIndex += 1
            newRowIndex += 1
        }

        return tableChanges
    }


    /// Gets rows from table safely.
    ///
    /// - Parameter table: table with rows
    /// - Returns: rows or empty array
    private func getRowsSafely(table: ClassificationTable?) -> [ClassificationRow] {
        if let table = table {
            return table.rows
        } else {
            return [ClassificationRow]()
        }
    }


    /// Detects change in row.
    ///
    /// - Parameters:
    ///   - oldItem: ClassificationRow
    ///   - newItem: ClassificationRow
    /// - Returns: found change or empty
    private func detectValueChange(oldItem: ClassificationRow?, newItem: ClassificationRow?)
                    -> DetectedChange<ClassificationRow>? {
        var type: DetectedChangeType?

        type = (oldItem == nil ? DetectedChangeType.added : nil)

        type = (newItem == nil ? DetectedChangeType.removed : type)

        if let old = oldItem, let new = newItem {
            if (old.name != new.name || old.value != new.value) {
                type = DetectedChangeType.modified
            }
        }

        if let type = type {
            return DetectedChange<ClassificationRow>(
                    type: type,
                    oldValue: oldItem,
                    newValue: newItem
            )
        }
        return nil
    }


    /// Counts total rows
    ///
    /// - Parameter value: ClassificationResult object
    /// - Returns: total row count
    private func countTotalRows(value: ClassificationResult) -> Int {
        return value.tables.reduce(0) {
            $0 + $1.rows.count
        }
    }
}
