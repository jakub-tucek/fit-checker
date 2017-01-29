//
// Created by Jakub Tucek on 28/01/17.
// Copyright (c) 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import RealmSwift

/// ObjectConvert is implementation of ObjectConvertingProtocol
class ObjectConvert: ObjectConverting {

    /// Converts database course to CourseParsedListResult
    ///
    /// - Parameter courseList: array of db courses
    /// - Returns: parsed result entity
    func convert(courseList: [Course]) -> CourseParsedListResult {
        let courseParsedList = courseList.map {
            CourseParsed(name: $0.name, classification: $0.classificationAvailable)
        }

        return CourseParsedListResult(courses: courseParsedList)
    }

    /// Coverts CourseParsedListResult to Course
    ///
    /// - Parameter courseParsed: parsed course result
    /// - Returns: array of db courses
    func convert(courseParsed: CourseParsedListResult) -> [Course] {
        return courseParsed.courses.map {
            Course(id: $0.name, name: $0.name, classificationAvailable: $0.classification)
        }
    }

    /// Coverts parsed classification result to array of CourseTable
    ///
    /// - Parameter parsedTableList: parsed result
    /// - Returns: array of db objects
    func convert(parsedTableList: ClassificationResult) -> [CourseTable] {
        return parsedTableList.tables.map {
            convert(parsedTable: $0)
        }
    }

    /// Converts array of tables to ClassificationResult
    ///
    /// - Parameter tableList: database courseTable list
    /// - Returns: classification result
    func convert(tableList: [CourseTable]) -> ClassificationResult {
        let res = ClassificationResult()

        res.tables = tableList.map {
            CourseParsedTable(name: $0.name, rows: convert(records: $0.classification))
        }

        return ClassificationResult()
    }

    func convert(parsedTable: CourseParsedTable) -> CourseTable {
        let courses = parsedTable.rows.map {
            ClassificationRecord(name: $0.name, score: $0.value)
        }

        return CourseTable(
                name: parsedTable.name,
                courseId: "unknown id",
                classification: courses)
    }

    func convert(records: RealmSwift.List<ClassificationRecord>) -> [ClassificationParsedRecord] {
        return Array(records).map {
            ClassificationParsedRecord(name: $0.name, value: $0.score)
        }

    }



}
