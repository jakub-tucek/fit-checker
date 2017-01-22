//
//  CourseListParserTest.swift
//  fit-checker
//
//  Created by Jakub Tucek on 14/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import XCTest

class CourseListParserTest: XCTestCase {

    let parser = CourseListParser()

    func convertToDictionary(text: String) -> [String: Any?]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?]
            } catch {
                Logger.shared.error(error.localizedDescription)
            }
        }
        return nil
    }

    func testHomepage() {
        let content = FileLoader.readFile(name: "lecture-list", ext: "json")!

        let result = parser.parseClassification(json: convertToDictionary(text: content)!)
        
        XCTAssertEqual("Semestr: Zimní 2016/2017", result.semesterInfo)
        XCTAssertEqual(8, result.courses.count)

        XCTAssertEqual("BI-SP2", result.courses[6].name)
        XCTAssertEqual(true, result.courses[6].classification)

        XCTAssertEqual("TVV0", result.courses[7].name)
        XCTAssertEqual(false, result.courses[7].classification)

    }

}
