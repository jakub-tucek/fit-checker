//
//  ClassificationParsing.swift
//  fit-checker
//
//  Created by Jakub Tucek on 12/01/17.
//  Copyright © 2017 JT-JD. All rights reserved.
//

import Foundation


/// ClassificationParsing is protocol for parsing edux.
protocol ClassificationParsing {


    /// Parses classification results from edux webpage.
    ///
    /// - Parameter html: downloaded html
    /// - Returns: parsed result
    func parse(html: String) -> ClassificationResult

}
