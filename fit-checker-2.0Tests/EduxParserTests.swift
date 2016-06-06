//
//  EduxParserTests.swift
//  fit-checker-2.0
//
//  Created by Jakub Tucek on 06/06/16.
//  Copyright © 2016 jakubtucek. All rights reserved.
//

import XCTest

class EduxParserTests : XCTestCase {
    
    let eduxParser = EduxParser()
    
    func testLecturesParser() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource("lectureList", ofType: "html")!
        let nsDataContent = NSData(contentsOfFile: path)
        let data = String(data: nsDataContent!, encoding: NSUTF8StringEncoding)
        
        let res = eduxParser.parseLectureList(data!)
        
        let correctResult = ["BI-BEZ",
                             "BI-EJA",
                             "BI-GRA",
                             "BI-OSY",
                             "BI-PSI",
                             "BI-SI1.2",
                             "BI-SP1",
                             "FI-FIL" ]
        XCTAssertTrue(res.elementsEqual(correctResult))
    }
    
    func testClassificationParser() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource("classificationTwoGroups", ofType: "html")!
        let nsDataContent = NSData(contentsOfFile: path)
        let data = String(data: nsDataContent!, encoding: NSUTF8StringEncoding)
        
        let res = eduxParser.parseClassification(data!)
        
       
        let correctResult = [("tutorial", [("1. cvičení", "√"), ("2. cvičení", "-"), ("Celkem", "52.71"), ("Nárok na zápočet", "Z"), ("Zápočet", "-")]), ("lecture", [("Midterm", "26"), ("Velká písemka", "12"), ("celkem", "90"), ("Známka", "A")])]
        XCTAssertTrue(res.count == correctResult.count)
        
        var counter = 0
        for r in res {
            XCTAssertTrue(r.0 == correctResult[counter].0)
            XCTAssertTrue(r.1.count == correctResult[counter].1.count)

            var tupletCounter = 0
            for tuplet in r.1 {
                XCTAssertTrue(tuplet.0 == correctResult[counter].1[tupletCounter].0)
                XCTAssertTrue(tuplet.1 == correctResult[counter].1[tupletCounter].1)
                tupletCounter += 1
            }
            counter += 1
        }
    }
}