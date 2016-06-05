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
    func parseClassification(html: String)-> [[String]] {
        var classification = [[String]]()
        var first = true
        var tmp = [" ","-"]
        
        if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
            for node in doc.xpath("//div[contains(@class,'page_with_sidebar')]") {
                for node2 in node.xpath("//tr/td") {
                    if let text = node2.text {
                        if text != "" {
                            let textStripped = text.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                            if first {
                                tmp[0] = textStripped
                            } else {
                                tmp[1] = textStripped
                            }
                        }
                    }
                    if !first {
                        classification.append(tmp)
                        tmp[0] = ""
                        tmp[1] = "-"
                    }
                    first = !first
                }
            }
        }
    
        return classification
    }
    
}