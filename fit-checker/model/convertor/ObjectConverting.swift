//
// Created by Jakub Tucek on 28/01/17.
// Copyright (c) 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

/// Protocol for converting between internal and database objects.
protocol ObjectConverting {


    /// Converts database course to CourseParsedListResult
    ///
    /// - Parameter courseList: array of db courses
    /// - Returns: parsed result entity
    static func convert(courseList: [Course]) -> CourseParsedListResult


    /// Coverts CourseParsedListResult to Course
    ///
    /// - Parameter courseParsed: parsed course result
    /// - Returns: array of db courses
    static func convert(courseParsed: CourseParsedListResult) -> [Course]


    /// Coverts parsed classification result to array of CourseTable
    ///
    /// - Parameter parsedTableList: parsed result
    /// - Returns: array of db objects
    static func convert(parsedTableList: ClassificationResult) -> [CourseTable]


    /// Converts array of tables to ClassificationResult
    ///
    /// - Parameter tableList: database courseTable list
    /// - Returns: classification result
    static func convert(tableList: [CourseTable]) -> ClassificationResult


    /// Converts parsed table to database table
    ///
    /// - Parameter parsedTable: parsed table
    /// - Returns: dabatase object
    static func convert(parsedTable: CourseParsedTable) -> CourseTable



    /// Converts real list of Classification records to internal records
    ///
    /// - Parameter records: realm list of records
    /// - Returns: array of records
    static func convert(records: RealmSwift.List<ClassificationRecord>) -> [ClassificationParsedRecord]


}
