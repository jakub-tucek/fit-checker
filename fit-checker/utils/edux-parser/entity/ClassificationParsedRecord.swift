//
//  ClassificationParsedRecord.swift
//  fit-checker
//
//  Created by Jakub Tucek on 12/01/17.
//  Copyright © 2017 JT-JD. All rights reserved.
//

import Foundation

/// EduxParserResultRow is class storing data of one row.
class ClassificationParsedRecord {

    /// Represents first column in table
    let name: String

    /// Represents second column in table - typically result of test, final grade
    let value: String

    init(name: String, value: String) {
        self.name = name
        self.value = value
    }


    static func !=(left: ClassificationParsedRecord, right: ClassificationParsedRecord) -> Bool {
        return !((left.name == right.name) && (left.value == right.value))
    }


}
