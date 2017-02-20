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
    enum RequestData {
        case multiEncoded(method: HTTPMethod, path: String, query: Parameters, body: Parameters)
        case singleEncoded(method: HTTPMethod, path: String, parameters: Parameters?)
    }

    case login(query: Parameters, body: Parameters)
    case courseClassification(courseId: String, student: String)
    case courseList(query: Parameters, body: Parameters)

    /// Edux site base URL
    static let baseURLString = "https://edux.fit.cvut.cz/"

    /// Returns route associated values as request configuration
    var requestData: RequestData {
        switch self {
        case let .login(query, body):
            return .multiEncoded(method: .post, path: "start", query: query, body: body)
        case let .courseClassification(courseId, student):
            return .singleEncoded(method: .get, path: "courses/\(courseId)/classification/student/\(student)/start", parameters: nil)
        case let .courseList(query, body):
            return .multiEncoded(method: .post, path: "lib/exe/ajax.php", query: query, body: body)
        }
    }
}


// MARK: - URLRequestConvertible
extension EduxRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let data = requestData
        let url = try EduxRouter.baseURLString.asURL()

        // As some requests requires both query string parameters and
        // body parameters, we need to encoded parameters twice
        switch data {
        case .multiEncoded(let method, let path, let query, let body):
            let urlRequest = URLRequest(url: url.appendingPathComponent(path))
            var urlEncoded = try URLEncoding.queryString.encode(urlRequest, with: query)

            urlEncoded.httpMethod = method.rawValue

            return try URLEncoding.default.encode(urlEncoded, with: body)
        case .singleEncoded(let method, let path, let parameters):
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))

            urlRequest.httpMethod = method.rawValue
            
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}
