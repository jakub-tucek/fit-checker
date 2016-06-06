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
                    let text = cleanText(text)
                    
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
    func parseClassification(html: String)-> [(String,[(String,String)])] {
        var classification = [(String,[(String,String)])]()
        
        if let htmlElement = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
            for divContent in htmlElement.xpath("//div[contains(@class,'page_with_sidebar')]") {
                if let divContentHTML = divContent.innerHTML {
                    if let divContentElement = Kanna.HTML(html: divContentHTML, encoding: NSUTF8StringEncoding) {
                        var titles = loadTitles(divContentElement)
                        if (titles.count == 0) {
                            titles.append("")
                        }
                        //print("titles")
                        //print(titles)
                        var titleCounter = 0;
                        //print(classification)

                        for table in divContentElement.xpath("//table") {
                            if let tableHtml = table.innerHTML {
                                if let tableElement = Kanna.HTML(html: tableHtml, encoding: NSUTF8StringEncoding) {
                                    let results = loadResultsForTable(tableElement)
                                    
                                    classification.append((titles[titleCounter], results))
                                    titleCounter += 1
                                }
                            }
                        }
                    }
                }
            }
        }

        return classification
    }
    func loadTitles(divContentElement : HTMLDocument) -> [String] {
        var titles = [String]()
        for title in divContentElement.xpath("//h2") {
            if let t = title.text {
                let cleanTitle = cleanText(t)
                titles.append(cleanTitle)
            }
        }
        return titles
    }
    func loadResultsForTable(table : HTMLDocument) -> [(String,String)] {
        var results = [(String,String)]()
        
        for row in table.xpath("//tr") {
            var first = true
            var tmp = (" ", "-")
            //print(row.text!)
            if let rowHTML = row.innerHTML {
                if let rowElement = Kanna.HTML(html: rowHTML, encoding: NSUTF8StringEncoding) {
                    for colWrap in rowElement.xpath("//td") {
                        if let col = colWrap.text {
                            if col != "" {
                                let colClean = cleanText(col)
                                if first {
                                    tmp.0 = colClean
                                    first = false
                                } else {
                                    tmp.1 = colClean
                                    break
                                }
                            }
                        }
                    }
                }
            }
            if (tmp.0 != " ") {
                results.append(tmp)
            }
        }
        return results
    }
    
    func cleanText(text : String) -> String {
        //Stripping new lines
        var cleanText = text.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        //Stripping multiple whitespaces
        cleanText = cleanText.stringByReplacingOccurrencesOfString("  ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        return cleanText
    }
}