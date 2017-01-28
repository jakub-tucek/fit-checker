//
// Created by Jakub Tucek on 28/01/17.
// Copyright (c) 2017 Josef Dolezal. All rights reserved.
//

import Foundation

class CourseTableConvertor {

    func convert(courseList: [Course]) -> CourseParsedListResult {
        let courseParsedList = courseList.map {
            CourseParsed(name: $0.name, classification: $0.classificationAvailable)
        }

        return CourseParsedListResult(courses: courseParsedList)
    }

    func convert(courseParsed: CourseParsedListResult) -> [Course] {
        return courseParsed.courses.map {
            Course(id: $0.name, name: $0.name, classificationAvailable: $0.classification)
        }
    }


}
