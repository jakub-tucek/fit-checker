//
//  EduxValidators.swift
//  fit-checker
//
//  Created by Josef Dolezal on 20/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire


struct EduxValidators {

    /// Shared validator constants
    struct Constants {
        /// If verifier is contained in HTML response, user is logged in
        static let loginHTMLVerifier = "Odhlásit se"

        /// If verifier is contained in JSON response, user is logged in
        static let loginJSONVerifier = "Studuji:"
    }

    /// Possible edux validation errors
    ///
    /// - generalError: Unrecognized error during request processing
    /// - badCredentials: User is not logged in
    enum ValidationError: Error {
        case generalError
        case badCredentials
    }

    /// Checks whether user is logged in (for HTML requests only)
    ///
    /// - Parameters:
    ///   - request: Original URL request
    ///   - response: Server response
    ///   - data: Response data
    /// - Returns: Failure if login was not successfull, success otherwise
    static func validateLoginHTML(request: URLRequest?, response:
        HTTPURLResponse, data: Data?) -> Request.ValidationResult {

        return dataContainsVerifier(data: data, verifier:
            Constants.loginHTMLVerifier)
    }

    /// Checks whether user is logged in (for JSON requests only)
    ///
    /// - Parameters:
    ///   - request: Original URL request
    ///   - response: Server response
    ///   - data: Response data
    /// - Returns: Failure if login was not successfull, success otherwise
    static func validateLoginJSON(request: URLRequest?, response:
        HTTPURLResponse, data: Data?) -> Request.ValidationResult {

        return dataContainsVerifier(data: data, verifier:
            Constants.loginJSONVerifier)
    }

    /// Checks if response containts verifier
    ///
    /// - Parameters:
    ///   - data: Response body
    ///   - verifier: Verifier which should be in body
    /// - Returns: .success if validator is presented, .failure otherwise
    private static func dataContainsVerifier(data: Data?, verifier:
        String) -> Request.ValidationResult {

        guard
            // This is legit since both JSON and HTML
            // response should have body and the body
            // should be representable by string
            let data = data,
            let html = String(data: data, encoding: .utf8) else {

                return .failure(ValidationError.generalError)
        }

        return html.contains(verifier)
            ? .success
            : .failure(ValidationError.badCredentials)
    }
}
