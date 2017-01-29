//
//  ClassificationDetectTest.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import XCTest

class ClassificationDetectTest: XCTestCase {

    let detect = ClassificationDetect()

    var oldRes = ClassificationResult()
    var newRes = ClassificationResult()

    override func setUp() {
        super.setUp()

        oldRes = initResult()
        newRes = initResult()
    }

    private func initResult() -> ClassificationResult {
        let res = ClassificationResult()
        let table1 = CourseParsedTable(
                name: "big table",
                rows: [ClassificationParsedRecord(name: "Value", value: "22"), ClassificationParsedRecord(name: "Value", value: "0")]
        )
        let table2 = CourseParsedTable(
                name: "small table",
                rows: [ClassificationParsedRecord(name: "Sparta", value: "VELKA NULA")]
        )
        res.tables = [table1, table2]

        return res
    }


    public func testNoChange() {
        let res = detect.detect(oldValue: oldRes, newValue: newRes)

        XCTAssertEqual(0, res.sizeDifference)
        XCTAssertEqual(0, res.changes.count)
        XCTAssertFalse(res.changeDetected())
    }

    public func testRowChange() {
        newRes.tables[0].rows[0] = ClassificationParsedRecord(name: "Value", value: "0")
        newRes.tables[1].rows[0] = ClassificationParsedRecord(name: "Atheny", value: "VELKA NULA")

        let res = detect.detect(oldValue: oldRes, newValue: newRes)

        XCTAssertEqual(0, res.sizeDifference)
        XCTAssertEqual(2, res.changes.count)
        XCTAssertEqual(DetectedChangeType.modified, res.changes[0].type)
        XCTAssertEqual("Value", res.changes[0].oldValue!.name)
        XCTAssertEqual("22", res.changes[0].oldValue!.value)
        XCTAssertEqual("Value", res.changes[0].newValue!.name)
        XCTAssertEqual("0", res.changes[0].newValue!.value)


        checkSecondTableChange(res: res)
        XCTAssertTrue(res.changeDetected())
    }

    public func testRowAdded() {
        newRes.tables[0].rows.append(ClassificationParsedRecord(name: "Value", value: "0"))
        newRes.tables[1].rows[0] = ClassificationParsedRecord(name: "Atheny", value: "VELKA NULA")

        let res = detect.detect(oldValue: oldRes, newValue: newRes)

        XCTAssertEqual(1, res.sizeDifference)
        XCTAssertEqual(2, res.changes.count)
        XCTAssertEqual(DetectedChangeType.added, res.changes[0].type)
        XCTAssertNil(res.changes[0].oldValue)
        XCTAssertEqual("Value", res.changes[0].newValue!.name)
        XCTAssertEqual("0", res.changes[0].newValue!.value)

        checkSecondTableChange(res: res)
        XCTAssertTrue(res.changeDetected())
    }

    private func checkSecondTableChange(res: ResultChange<ClassificationParsedRecord>) {
        XCTAssertEqual(DetectedChangeType.modified, res.changes[1].type)
        XCTAssertEqual("Sparta", res.changes[1].oldValue!.name)
        XCTAssertEqual("VELKA NULA", res.changes[1].oldValue!.value)
        XCTAssertEqual("Atheny", res.changes[1].newValue!.name)
        XCTAssertEqual("VELKA NULA", res.changes[1].newValue!.value)
    }

    public func testRowRemoved() {
        newRes.tables[0].rows.removeLast()
        newRes.tables[1].rows[0] = ClassificationParsedRecord(name: "Atheny", value: "VELKA NULA")

        let res = detect.detect(oldValue: oldRes, newValue: newRes)

        XCTAssertEqual(-1, res.sizeDifference)
        XCTAssertEqual(2, res.changes.count)
        XCTAssertEqual(DetectedChangeType.removed, res.changes[0].type)
        XCTAssertNil(res.changes[0].newValue)
        XCTAssertEqual("Value", res.changes[0].oldValue!.name)
        XCTAssertEqual("0", res.changes[0].oldValue!.value)

        checkSecondTableChange(res: res)
        XCTAssertTrue(res.changeDetected())
    }
}
