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
    /// - badCredentials: Given user credentials are not valid (thrown at login)
    /// - unauthorized: User is not logged in
    enum ValidationError: Error {
        case generalError
        case badCredentials
        case unauthorized
    }

    /// Validates if login request was successfull. It uses authorizedHTML
    /// validator under the hood but returns different error.
    /// Usualy used only to check if cookies was obtained successfully.
    ///
    /// - Parameters:
    ///   - request: Original request
    ///   - response: Server response
    ///   - data: Response body
    /// - Returns: Failure if request did not contained valid credentials
    static func validCredentials(request: URLRequest?, response:
        HTTPURLResponse, data: Data?) -> Request.ValidationResult {

        let result = authorizedHTML(request: request,
                                    response: response, data: data)

        switch result {
        case .success: return result
        case .failure: return .failure(ValidationError.badCredentials)
        }
    }

    /// Checks whether user is logged in (for HTML requests only).
    /// Used for common HTML requests, not user authorization.
    /// If you use it during authorization, you could make
    /// infinite requests calling. Use this validator if you want
    /// your request to be retriable.
    ///
    /// - Parameters:
    ///   - request: Original URL request
    ///   - response: Server response
    ///   - data: Response data
    /// - Returns: Failure if login was not successfull, success otherwise
    static func authorizedHTML(request: URLRequest?, response:
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
    static func authorizedJSON(request: URLRequest?, response:
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
