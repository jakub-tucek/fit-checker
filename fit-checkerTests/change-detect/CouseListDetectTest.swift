//
//  CourseListDetectTest.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import XCTest

class CourseListDetectTest: XCTestCase {

    let detect = CourseListDetect()

    var oldRes = CourseParsedListResult()
    var newRes = CourseParsedListResult()

    override func setUp() {
        super.setUp()

        oldRes = initResult()
        newRes = initResult()
    }

    private func initResult() -> CourseParsedListResult {
        let res = CourseParsedListResult()
        res.semesterInfo = "semester info"
        let course = [CourseParsed(name: "SP2"), CourseParsed(name: "SP3"), CourseParsed(name: "SI3.0")]
        res.courses = course

        return res
    }


    func testNoChange() {
        let detectResult = detect.detect(oldValue: oldRes, newValue: newRes)

        noListChangeAsserts(res: detectResult)
        XCTAssertFalse(detectResult.changeDetected())
    }

    func testSemesterInfoChange() {
        newRes.semesterInfo = "semester info new"

        let detectResult = detect.detect(oldValue: oldRes, newValue: newRes)


        noListChangeAsserts(res: detectResult)

        XCTAssertEqual("semester info new", detectResult.semesterChange!.newValue)
        XCTAssertEqual("semester info", detectResult.semesterChange!.oldValue)
        XCTAssertEqual(DetectedChangeType.modified, detectResult.semesterChange!.type)
        XCTAssertTrue(detectResult.changeDetected())
    }


    func testSemesterNewMissing() {
        newRes.semesterInfo = ""

        let detectResult = detect.detect(oldValue: oldRes, newValue: newRes)


        noListChangeAsserts(res: detectResult)

        XCTAssertEqual("", detectResult.semesterChange!.newValue)
        XCTAssertEqual("semester info", detectResult.semesterChange!.oldValue)
        XCTAssertEqual(DetectedChangeType.removed, detectResult.semesterChange!.type)
        XCTAssertTrue(detectResult.changeDetected())
    }

    func testSemesterOldMissing() {
        oldRes.semesterInfo = ""

        let detectResult = detect.detect(oldValue: oldRes, newValue: newRes)


        noListChangeAsserts(res: detectResult)

        XCTAssertEqual("", detectResult.semesterChange!.oldValue)
        XCTAssertEqual("semester info", detectResult.semesterChange!.newValue)
        XCTAssertEqual(DetectedChangeType.added, detectResult.semesterChange!.type)
        XCTAssertTrue(detectResult.changeDetected())
    }

    private func noListChangeAsserts(res: CourseListResultChange) {
        XCTAssertEqual(0, res.sizeDifference)
        XCTAssertEqual(0, res.changes.count)
    }


    func testDifferentName() {
        newRes.courses[0] = CourseParsed(name: "Diff name")

        let detectResult = detect.detect(oldValue: oldRes, newValue: newRes)


        XCTAssertEqual(0, detectResult.sizeDifference)
        XCTAssertEqual(1, detectResult.changes.count)

        XCTAssertEqual("Diff name", detectResult.changes[0].newValue!.name)
        XCTAssertEqual("SP2", detectResult.changes[0].oldValue!.name)
        XCTAssertEqual(DetectedChangeType.modified, detectResult.changes[0].type)

        XCTAssertTrue(detectResult.changeDetected())
    }


    func testMissingNewName() {
        newRes.courses.remove(at: 2)

        let detectResult = detect.detect(oldValue: oldRes, newValue: newRes)


        XCTAssertEqual(-1, detectResult.sizeDifference)
        XCTAssertEqual(1, detectResult.changes.count)

        XCTAssertNil(detectResult.changes[0].newValue)
        XCTAssertEqual("SI3.0", detectResult.changes[0].oldValue!.name)
        XCTAssertEqual(DetectedChangeType.removed, detectResult.changes[0].type)

        XCTAssertTrue(detectResult.changeDetected())
    }

    func testAddedNewName() {
        oldRes.courses.remove(at: 2)

        let detectResult = detect.detect(oldValue: oldRes, newValue: newRes)


        XCTAssertEqual(1, detectResult.sizeDifference)
        XCTAssertEqual(1, detectResult.changes.count)

        XCTAssertNil(detectResult.changes[0].oldValue)
        XCTAssertEqual("SI3.0", detectResult.changes[0].newValue!.name)
        XCTAssertEqual(DetectedChangeType.added, detectResult.changes[0].type)

        XCTAssertTrue(detectResult.changeDetected())
    }

}
