//
//  EduxRouter.swift
//  fit-checker
//
//  Created by Josef Dolezal on 13/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire


/// Edux requests router.
enum EduxRouter {
    /// Remote request configuration data
    typealias RequestData = (method: HTTPMethod, path: String,
        parameters: Parameters?)

    case login(parameters: Parameters)
    case courseClassification(subjectCode: String, student: String)
    case courseList(parameters: Parameters)

    /// Edux site base URL
    static let baseURLString = ""

    /// Returns route associated values as request configuration
    var requestData: RequestData {
        switch self {
        case .login(let parameters): return (.post, "login", parameters)
        case .courseClassification(let subjectCode, let student): return (.get, "courses/\(subjectCode)/classification/student/\(student)/start", nil)
        case .courseList(let parameters): return (.post, "lib/exe/ajax.php?dashboard_current_lang=cs", parameters)
        }
    }
}


// MARK: - URLRequestConvertible
extension EduxRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let data = requestData
        let url = try EduxRouter.baseURLString.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(data.path))

        return try URLEncoding.default.encode(urlRequest, with: data.parameters)
    }
}
