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

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func convertToDictionary(text: String) -> [String: Any?]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?]
            } catch {
                Logger.share.error(error.localizedDescription)
            }
        }
        return nil
    }

    func testHomepage() {
        let content = FileLoader.readFile(name: "lecture-list", ext: "json")!

        let result = parser.parseClassification(json: convertToDictionary(text: content)!)
        
        XCTAssertEqual("Semestr: Zimní 2016/2017", result.semesterInfo)
        XCTAssertEqual(8, result.lectures.count)

    }

}
