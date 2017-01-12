//
//  EduxParserResultTable.swift
//  fit-checker
//
//  Created by Jakub Tucek on 12/01/17.
//  Copyright © 2017 JT-JD. All rights reserved.
//

import Foundation


/// EduxParserResultTable is class keeping array of rows.
class EduxParserResultTable {


    /// Name of table if present
    private var name : String?

    // All rows in table
    private var rows = [EduxParserResultRow]()

    init() {
        //Empty constructor
    }

    init(name : String) {
        self.name = name
    }
    
    func addRow(newRow : EduxParserResultRow) {
        rows.append(newRow)
    }
    
    func addRows(newRows: [EduxParserResultRow]) {
        rows = rows + newRows
    }
    
}
