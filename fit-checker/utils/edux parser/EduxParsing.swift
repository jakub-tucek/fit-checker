//
//  EduxParsing.swift
//  fit-checker
//
//  Created by Jakub Tucek on 12/01/17.
//  Copyright © 2017 JT-JD. All rights reserved.
//

import Foundation


/// EduxParsing is protocol for parsing edux.
protocol EduxParsing {


    /// Parses result from edux webpage.
    ///
    /// - Parameter html: downloaded html
    /// - Returns: parsed resut
    func parseEdux(html: String) -> EduxParserResult

}
