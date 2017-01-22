//
//  CourseListParsing.swift
//  fit-checker
//
//  Created by Jakub Tucek on 14/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// CourseParsedListParsing is protocol for parsing edux homepage that contains
/// courses of current semester.
protocol CourseListParsing {


    /// Parses classification from edux homepage.
    ///
    /// - Parameter json: ajax response containg widget content in json format
    /// - Returns: parsed result
    func parseClassification(json: [String: Any?]) -> CourseParsedListResult


}
