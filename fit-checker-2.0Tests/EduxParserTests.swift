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
    
}