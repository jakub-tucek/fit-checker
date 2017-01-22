//
//  LectureListParserTest.swift
//  fit-checker
//
//  Created by Jakub Tucek on 14/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import XCTest

class LectureListParserTest: XCTestCase {

    let parser = LectureListParser()

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
        XCTAssertEqual(8, result.lectures.count)

        XCTAssertEqual("BI-SP2", result.lectures[6].name)
        XCTAssertEqual(true, result.lectures[6].classification)

        XCTAssertEqual("TVV0", result.lectures[7].name)
        XCTAssertEqual(false, result.lectures[7].classification)

    }

}
