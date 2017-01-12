//
//  EduxParserResult.swift
//  fit-checker
//
//  Created by Jakub Tucek on 12/01/17.
//  Copyright © 2017 JT-JD. All rights reserved.
//

import Foundation


/// EduxParserResult is class wrapping up result of parsing.
class EduxParserResult {


    /// All Tables
    private var tables = [EduxParserResultTable]()


    /// Timestamp when result was created
    private let timestamp = Date()

    func addTables(newTable : [EduxParserResultTable]) {
        tables = tables + newTable
    }


}
