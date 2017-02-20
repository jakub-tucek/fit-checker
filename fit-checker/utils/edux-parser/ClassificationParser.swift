//
//  ClassificationParser.swift
//  fit-checker
//
//  Created by Jakub Tucek on 13/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Kanna


/// ClassificationParser is implementation of ClassificaitonParsing protocol.
/// With help of Kanna framework and simple xpath selectors parses classification
/// page. Result is returned in ClassificationResult object.
class ClassificationParser: ClassificationParsing {


    struct Consts {
        /// Selectors main div containing all data
        static let mainDivSelector = "//div[contains(@class, 'page_with_sidebar')]" +
                "/div[contains(@class, 'level1')]"

        /// Selects table names
        static let tableNameSelector = "h2"

        /// Selects tbody containing row with data
        static let tableSelector = "div/table/tbody"

        /// One row in table
        static let rowSelector = "tr"

        /// One col in row
        static let colSelector = "td"
    }


    /// Parses classification page - all of tables and its names and returns it.
    ///
    /// - Parameter html: html to parse
    /// - Returns: result of parsing
    func parse(html: String) -> ClassificationResult {
        let result = ClassificationResult()

        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            for node in doc.xpath(Consts.mainDivSelector) {

                let tables = parseTables(node: node)

                result.tables = tables
            }
        }


        return result
    }


    /// Parsers all table names - if empty puts empty string to array.
    ///
    /// - Parameter node: node of main div
    /// - Returns: Ordered String array of names
    private func parseTableNames(node: XMLElement) -> [String] {
        var names = [String]()

        for titleNode in node.xpath(Consts.tableNameSelector) {
            if let title = titleNode.text {
                names.append(title)
            } else {
                names.append("")
            }
        }

        return names
    }


    /// Parses one table by iterating over all rows and calling self#parseRow
    /// method.
    ///
    /// - Parameters:
    ///   - tableNode: tbody node
    ///   - name: name of table - empty String if has no name
    /// - Returns: parsed table
    private func parseTable(tableNode: XMLElement, name: String) -> CourseParsedTable {
        var rows = [ClassificationParsedRecord]()
        for rowNode in tableNode.xpath(Consts.rowSelector) {
            if let row = parseRow(rowNode: rowNode) {
                rows.append(row)
            }
        }

        return CourseParsedTable(name: name, rows: rows)
    }


    /// Parses all tables and returns them as array.
    /// First parses all names, then calls self#parseTable with proper
    /// name (based on order) and tbody part of table.
    ///
    /// - Parameter node: main div
    /// - Returns: array of table objects
    private func parseTables(node: XMLElement) -> [CourseParsedTable] {
        var tableCounter = 0
        var tables = [CourseParsedTable]()
        let names = parseTableNames(node: node)

        for tableNode in node.xpath(Consts.tableSelector) {

            tables.append(
                    self.parseTable(
                            tableNode: tableNode,
                            name: names[tableCounter]
                    )
            )

            tableCounter += 1
        }

        return tables
    }


    /// Parses one row into array (of max size of 2). If size is == 2 then
    /// ClassificationRow object is created from those values.
    ///
    /// - Parameter rowNode: row (tr) node
    /// - Returns: optional of row object | empty if row has < 2 collumns
    private func parseRow(rowNode: XMLElement) -> ClassificationParsedRecord? {
        var orderedCol = [String]()
        var limit = 0

        for colNode in rowNode.xpath(Consts.colSelector) {

            if (limit >= 2) {
                break
            }

            if let value = colNode.innerHTML {
                orderedCol.append(value.replacingOccurrences(of: "\n", with: ""))
            } else {
                orderedCol.append("")
            }

            limit += 1
        }

        if (limit != 2) {
            return nil
        } else {
            return ClassificationParsedRecord(name: orderedCol[0], value: orderedCol[1])
        }
    }

}
