//
// Created by Jakub Tucek on 28/01/17.
// Copyright (c) 2017 Josef Dolezal. All rights reserved.
//

import Foundation

protocol ObjectConverting {

    func convert(courseList: [Course]) -> CourseParsedListResult

    func convert(courseParsed: CourseParsedListResult) -> [Course]

    func convert(parsedTableList: [ClassificationTable]) -> [CourseTable]

    func convert(tableList: [CourseTable]) -> [ClassificationTable]

}
