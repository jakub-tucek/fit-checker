//
//  LectureListParsing.swift
//  fit-checker
//
//  Created by Jakub Tucek on 14/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// LectureListParsing is protocal for parsing edux homepage that contains
/// courses of current semester.
protocol LectureListParsing {


    /// Parses classification from edux homepage.
    ///
    /// - Parameter html: html to parse
    /// - Returns: parsed result
    func parseClassification(html: String) -> LectureListResult


}
