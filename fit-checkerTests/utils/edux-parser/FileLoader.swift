//
//  FileLoader.swift
//  fit-checker
//
//  Created by Jakub Tucek on 14/01/17.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation

class FileLoader {

    static func readFile(name: String, ext: String = "html") -> String? {
        let testBundle = Bundle(for: FileLoader.self)
        guard let ressourceURL = testBundle.url(forResource: name, withExtension: ext) else {
            // file does not exist
            return nil
        }
        do {
            let resourceData = try Data(contentsOf: ressourceURL)
            let datastring = String(data: resourceData, encoding: .utf8)

            return datastring!
        } catch _ {
            // some error occurred when reading the file
        }

        return nil
    }

}
