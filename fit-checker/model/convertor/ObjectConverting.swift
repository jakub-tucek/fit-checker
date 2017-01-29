//
// Created by Jakub Tucek on 28/01/17.
// Copyright (c) 2017 Josef Dolezal. All rights reserved.
//

import Foundation

//Protocol for converting between internal and database objects.
protocol ObjectConverting {

    func convert(courseList: [Course]) -> CourseParsedListResult

    func convert(courseParsed: CourseParsedListResult) -> [Course]

    func convert(parsedTableList: ClassificationResult) -> [CourseTable]

    func convert(tableList: [CourseTable]) -> ClassificationResult

}
