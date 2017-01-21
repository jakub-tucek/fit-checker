//
//  LectureListDetectTest.swift
//  fit-checker
//
//  Created by Jakub Tucek on 21/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import XCTest

class LectureListDetectTest: XCTestCase {

    let detect = LectureListDetect()

    var oldRes = LectureListResult()
    var newRes = LectureListResult()

    override func setUp() {
        super.setUp()

        oldRes = initResult()
        newRes = initResult()
    }

    private func initResult() -> LectureListResult {
        let res = LectureListResult()
        res.semesterInfo = "semester info"
        let lecture = [Lecture(name: "SP2"), Lecture(name: "SP3"), Lecture(name: "SI3.0")]
        res.lectures = lecture

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
        XCTAssertEqual(ChangeType.modified, detectResult.semesterChange!.type)
        XCTAssertTrue(detectResult.changeDetected())
    }


    func testSemesterNewMissing() {
        newRes.semesterInfo = ""

        let detectResult = detect.detect(oldValue: oldRes, newValue: newRes)


        noListChangeAsserts(res: detectResult)

        XCTAssertEqual("", detectResult.semesterChange!.newValue)
        XCTAssertEqual("semester info", detectResult.semesterChange!.oldValue)
        XCTAssertEqual(ChangeType.removed, detectResult.semesterChange!.type)
        XCTAssertTrue(detectResult.changeDetected())
    }

    func testSemesterOldMissing() {
        oldRes.semesterInfo = ""

        let detectResult = detect.detect(oldValue: oldRes, newValue: newRes)


        noListChangeAsserts(res: detectResult)

        XCTAssertEqual("", detectResult.semesterChange!.oldValue)
        XCTAssertEqual("semester info", detectResult.semesterChange!.newValue)
        XCTAssertEqual(ChangeType.added, detectResult.semesterChange!.type)
        XCTAssertTrue(detectResult.changeDetected())
    }

    private func noListChangeAsserts(res: LectureListResultChange) {
        XCTAssertEqual(0, res.sizeDifference)
        XCTAssertEqual(0, res.changes.count)
    }


    func testDifferentName() {
        newRes.lectures[0] = Lecture(name: "Diff name")

        let detectResult = detect.detect(oldValue: oldRes, newValue: newRes)


        XCTAssertEqual(0, detectResult.sizeDifference)
        XCTAssertEqual(1, detectResult.changes.count)

        XCTAssertEqual("Diff name", detectResult.changes[0].newValue!.name)
        XCTAssertEqual("SP2", detectResult.changes[0].oldValue!.name)
        XCTAssertEqual(ChangeType.modified, detectResult.changes[0].type)

        XCTAssertTrue(detectResult.changeDetected())
    }


    func testMissingNewName() {
        newRes.lectures.remove(at: 2)

        let detectResult = detect.detect(oldValue: oldRes, newValue: newRes)


        XCTAssertEqual(-1, detectResult.sizeDifference)
        XCTAssertEqual(1, detectResult.changes.count)

        XCTAssertNil(detectResult.changes[0].newValue)
        XCTAssertEqual("SI3.0", detectResult.changes[0].oldValue!.name)
        XCTAssertEqual(ChangeType.removed, detectResult.changes[0].type)

        XCTAssertTrue(detectResult.changeDetected())
    }

}
