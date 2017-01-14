//
//  EduxParser.swift
//  fit-checker
//
//  Created by Jakub Tucek on 13/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Kanna

class ClassificationParser: ClasificationParsing {

    let mainDivSelector = "//div[contains(@class, 'page_with_sidebar')]" +
                                "/div[contains(@class, 'level1')]"

    let tableNameSelector = "h2"

    let tableSelector = "div/table/tbody"

    let rowSelector = "tr"

    let colSelector = "td"


    func parseEdux(html: String) -> ClassificationResult {
        let result = ClassificationResult()

        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            for node in doc.xpath(self.mainDivSelector) {

                let tables = self.parseTables(node: node)

                result.tables = tables
            }
        }


        return result
    }

    private func parseTableNames(node: XMLElement) -> [String] {
        var names = [String]()

        for titleNode in node.xpath(self.tableNameSelector) {
            if let title = titleNode.text {
                names.append(title)
            } else {
                names.append("")
            }
        }

        return names
    }

    private func parseTable(tableNode: XMLElement, name: String) -> ClassificationTable {
        var rows = [ClassificationRow]()
        for rowNode in tableNode.xpath(self.rowSelector) {
            if let row = self.parseRow(rowNode: rowNode) {
                rows.append(row)
            }
        }

        return ClassificationTable(name: name, rows: rows)
    }

    private func parseTables(node: XMLElement) -> [ClassificationTable] {
        var tableCounter = 0
        var tables = [ClassificationTable]()
        let names = self.parseTableNames(node: node)

        for tableNode in node.xpath(self.tableSelector) {

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

    private func parseRow(rowNode: XMLElement) -> ClassificationRow? {
        var orderedCol = [String]()
        var limit = 0

        for colNode in rowNode.xpath(self.colSelector) {

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
            return ClassificationRow(name: orderedCol[0], value: orderedCol[1])
        }
    }

}
