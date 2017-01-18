//
//  EduxParserResult.swift
//  fit-checker
//
//  Created by Jakub Tucek on 12/01/17.
//  Copyright © 2017 JT-JD. All rights reserved.
//

import Foundation


/// EduxParserResult is class wrapping up result of parsing.
class ClassificationResult {


    /// All Tables
    var tables = [ClassificationTable]()


    /// Timestamp when result was created
    let timestamp = Date()

}
