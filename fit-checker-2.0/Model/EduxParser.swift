//
//  AppDelegate.swift
//  fit-checker-2.0
//
//  Created by Jakub Tucek on 05/06/16.
//  Copyright © 2016 jakubtucek. All rights reserved.
//

import Foundation
import Kanna

class EduxParser {
    
    
    /**
     Lecture list parser
     
     - parameter html: raw html page of ajax response with lectures
     
     - returns: array of strings representing lectures
     */
    func parseLectureList(html: String) -> [String] {
        var lectures = [String]()
        if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
            for node in doc.xpath("//li") {
                if let text = node.text {
                    //Stripping new lines
                    var text = text.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    
                    //Stripping multiple whitespaces
                    text = text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    
                    lectures.append(text)
                }
            }
        }
        return lectures
    }
    
    /**
     Lecture classification parser
     
     - parameter html: raw edux classification page
     
     - returns: returns parsed output
     */
    func parseClassification(html: String)-> [(String,[[String]])] {
        var classification = [(String(),[[String]]())]
        
        if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
            for contentDiv in doc.xpath("//div[contains(@class,'page_with_sidebar')]") {
                var titles = loadTitles(contentDiv)
                
                if (titles.count == 0) {
                    titles.append("")
                }
                
                var titleCounter = 0;
                for table in contentDiv.xpath("//table") {
                    let results = loadResultsForTable(table)
                    classification.append( (titles[titleCounter], results) )
                    
                    titleCounter += 1
                }
            }
        }
        return classification
    }
    func loadTitles(contentDiv : XMLElement) -> [String] {
        var titles = [String]()
        for title in contentDiv.xpath("//h2") {
            if let t = title.text {
                titles.append(t)
            }
        }
        return titles
    }
    func loadResultsForTable(table : XMLElement) -> [[String]] {
        var results = [[String]]()
        
        for row in table.xpath("//tr") {
            var first = true
            var tmp = [" ","-"]
            
            for colWrap in row.xpath("//td") {
                if let col = colWrap.text {
                    if col != "" {
                        let colStripped = col.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        if first {
                            tmp[0] = colStripped
                            first = false
                        } else {
                            tmp[1] = colStripped
                        }
                    }
                }
            }
            results.append(tmp)
        }
        return results
    }
}