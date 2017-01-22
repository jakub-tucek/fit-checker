//
//  CourseListParser.swift
//  fit-checker
//
//  Created by Jakub Tucek on 14/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Kanna


/// CourseListParser is implementation of CourseListParsing protocol.
/// Parses semester information and current courses (courses) from edux homepage.
class CourseListParser: CourseListParsing {


    /// Struct containing selector constants
    struct Consts {
        /// static let
        static let jsonContentKey = "widget_content"

        /// Select info about semester
        static let semesterInfoSelector
                = "//p[contains(@class, 'semester-info')]"

        /// Select course in list containing
        static let courseSelector
                = "//ul/li"

        static let courseLinkSelector
                = "a"
    }


    /// Parses classification from edux homepage.
    ///
    /// - Parameter json: ajax response containing widget content in json format
    /// - Returns: parsed result
    func parseClassification(json: [String: Any?]) -> CourseParsedListResult {
        let result = CourseParsedListResult()

        let html = getWidgetContent(json: json)

        if let node = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            let semesterInfo = parseSemesterInfo(widgetDocument: node)
            if let infoUnwrap = semesterInfo {
                result.semesterInfo = infoUnwrap

            }

            result.courses = parseLectures(widgetDocument: node)

        }
        return result
    }


    /// Gets html content from JSON.
    ///
    /// - Parameter json: response JSON of widget
    /// - Returns: html or empty string if JSON is not valid
    private func getWidgetContent(json: [String: Any?]) -> String {
        if let str = json[Consts.jsonContentKey] as? String {
            return str
        } else {
            return ""
        }
    }


    /// Parses semester informations. Finds first node that matches
    /// Semester info selector and returns it's text.
    ///
    /// - Parameter widgetNode: widget node
    /// - Returns: parsed semester info
    private func parseSemesterInfo(widgetDocument: HTMLDocument) -> String? {
        for infoNode in widgetDocument.xpath(Consts.semesterInfoSelector) {
            return infoNode.text
        }
        return nil
    }


    /// Parses courses names by iterating over li elements in list.
    ///
    /// - Parameter widgetNode: widget node
    /// - Returns: parsed courses
    private func parseLectures(widgetDocument: HTMLDocument) -> [CourseParsed] {
        var courses = [CourseParsed]()
        for courseNode in widgetDocument.xpath(Consts.courseSelector) {
            let linkNodeCount
                    = courseNode.xpath(Consts.courseLinkSelector).count

            //no link found
            let classification = (linkNodeCount > 0)

            if let name = courseNode.text {
                courses.append(CourseParsed(name: name, classification: classification))
            }
        }

        return courses
    }

}
