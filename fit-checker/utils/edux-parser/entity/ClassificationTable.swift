//
//  ClassificationTable.swift
//  fit-checker
//
//  Created by Jakub Tucek on 12/01/17.
//  Copyright © 2017 JT-JD. All rights reserved.
//

import Foundation


/// EduxParserResultTable is class keeping array of rows.
class ClassificationTable {


    /// Name of table if present
    var name: String?

    // All rows in table
    var rows: [ClassificationRow]

    init(name: String, rows: [ClassificationRow]) {
        self.name = name
        self.rows = rows
    }

}
