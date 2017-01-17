//
//  LectureListParser.swift
//  fit-checker
//
//  Created by Jakub Tucek on 14/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Kanna


/// LectureListParser is impelemntation of LectureListParsing protocol.
/// Parses semester information and current lectures (courses) from edux homepage.
class LectureListParser : LectureListParsing {


    /// Struct containg selector constants
    struct xpath {

        /// Select widget's div from page
        static let lecturesWidgetSelector
            = "//div[contains(@id, 'w_actual_courses_fit')]/div[contains(@class, 'content')]"

        /// Select info about semester
        static let semesterInfoSelector
            = "p[contains(@class, 'semester-info')]"

        /// Select lecture in list containing
        static let lectureSelector
            = "div/ul/li"
    }
    


    /// Parses classification from edux homepage.
    ///
    /// - Parameter html: html to parse
    /// - Returns: parsed result
    func parseClassification(html: String) -> LectureListResult {
        let result = LectureListResult()

        if let node = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            for widgetNode in node.xpath(xpath.lecturesWidgetSelector) {
                let semesterInfo = parseSemesterInfo(widgetNode: widgetNode)
                if let infoUnwrap = semesterInfo {
                    result.semesterInfo = infoUnwrap

                }

                result.lectures = parseLectures(widgetNode: widgetNode)
            }

        }
        return result
    }


    /// Parses semester informations. Finds first node that matches
    /// Semester infor selector and returns it's text.
    ///
    /// - Parameter widgetNode: widget node
    /// - Returns: parsed semester info
    private func parseSemesterInfo(widgetNode: XMLElement) -> String? {
        for infoNode in widgetNode.xpath(xpath.semesterInfoSelector) {
            return infoNode.text
        }
        return nil
    }


    /// Parses lectures names by iterating over li elements in list.
    ///
    /// - Parameter widgetNode: widget node
    /// - Returns: parsed lectures
    private func parseLectures(widgetNode: XMLElement) -> [Lecture] {
        var lectures = [Lecture]()
        for lectureNode in widgetNode.xpath(xpath.lectureSelector) {
            if let name = lectureNode.text {
                lectures.append(Lecture(name: name))
            }
        }

        return lectures
    }

}
