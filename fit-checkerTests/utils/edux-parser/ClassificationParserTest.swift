//
//  ClassificationParserTest.swift
//  fit-checker
//
//  Created by Jakub Tucek on 13/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import XCTest

class ClassificationParserTest: XCTestCase {

    let parser = ClassificationParser()

    //one table
    func testOMO() {
        let omoPage = FileLoader.readFile(name: "biomo")!

        let result = parser.parseEdux(html: omoPage)

        XCTAssertEqual(1, result.tables.count)

        XCTAssertEqual(6, result.tables[0].rows.count)
        XCTAssertEqual("tutorial", result.tables[0].name!)

        XCTAssertEqual("test", result.tables[0].rows[0].name)
        XCTAssertEqual("-", result.tables[0].rows[0].value)

        XCTAssertEqual("1kon", result.tables[0].rows[1].name)
        XCTAssertEqual("-", result.tables[0].rows[1].value)

        XCTAssertEqual("2kon", result.tables[0].rows[2].name)
        XCTAssertEqual("-", result.tables[0].rows[2].value)

        XCTAssertEqual("odevzdano", result.tables[0].rows[3].name)
        XCTAssertEqual("-", result.tables[0].rows[3].value)

        XCTAssertEqual("hodnoceni", result.tables[0].rows[4].name)
        XCTAssertEqual("-", result.tables[0].rows[4].value)

        XCTAssertEqual("zapocet", result.tables[0].rows[5].name)
        XCTAssertEqual("-", result.tables[0].rows[5].value)

    }

    //two tables
    func testPST() {
        let pstPage = FileLoader.readFile(name: "bipst")!

        let result = parser.parseEdux(html: pstPage)

        XCTAssertEqual(2, result.tables.count)

        XCTAssertEqual(17, result.tables[0].rows.count)
        XCTAssertEqual(12, result.tables[1].rows.count)

        XCTAssertEqual("Cvičení", result.tables[0].name!)
        XCTAssertEqual("Přednáška", result.tables[1].name!)


        XCTAssertEqual("Test 1", result.tables[0].rows[0].name)
        XCTAssertEqual("6", result.tables[0].rows[0].value)



        XCTAssertEqual("Cvičení", result.tables[1].rows[0].name)
        XCTAssertEqual("30", result.tables[1].rows[0].value)
    }

    //empty page
    func testSPTwo() {
        let pstPage = FileLoader.readFile(name: "bisp2")!

        let result = parser.parseEdux(html: pstPage)

        XCTAssertEqual(0, result.tables.count)
    }

}
