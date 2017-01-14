//
//  LectureListResult.swift
//  fit-checker
//
//  Created by Jakub Tucek on 14/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation


/// LectureListResult is object keeping info about parsing lectures.
class LectureListResult {


    /// Timestamp when result was created
    let timestamp = Date()

    var lectures = [Lecture]()
    
}
