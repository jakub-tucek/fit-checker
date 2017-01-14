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


    func testHomepage() {
        let content = FileLoader.readFile(name: "homepage", selfClass: self)!

        let result = parser.parseClassification(html: content)

        XCTAssertEqual("Semestr: Zimní 2016/2017", result.semesterInfo)
        XCTAssertEqual(6, result.lectures.count)

    }

}
