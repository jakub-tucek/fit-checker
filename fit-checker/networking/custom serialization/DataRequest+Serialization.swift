//
//  DataRequest+Serialization.swift
//  fit-checker
//
//  Created by Josef Dolezal on 29/01/2017.
//  Copyright © 2017 Josef Dolezal. All rights reserved.
//

import Foundation
import Alamofire

/// JSON dictionary alias
typealias JSON = [String: Any?]

/// Object JSON serialization protocol
protocol ResponseObjectSerializable {
    /// Creates new object from JSON data
    ///
    /// - Parameter json: Downloaded JSON
    /// - Returns: Object representation of JSON
    /// - Throws: ResponseObjectSerializationError
    static func setup(from json: JSON) throws -> Self
}

/// Serialization error
///
/// - dataSerialization: Occured when data could not be serialized (bad format)
/// - requestError: Uknown error for serialization
enum ResponseObjectSerializationError: Error {
    case dataSerialization(data: JSON?)
    case requestError
}

// MARK: - JSON to Object serialization
extension DataRequest {

    /// Creates Object representation of JSON response
    ///
    /// - Parameters:
    ///   - queue: Dispatch queue
    ///   - completionHandler: Completion handler
    /// - Returns: Serialized object on success, error on failure
    func responseObject<Object: ResponseObjectSerializable>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<Object>) -> Void)
        -> Self
    {
        let responseSerializer = DataResponseSerializer<Object> { request, response, data, error in
            guard error == nil else { return .failure(error!) }

            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)

            guard case let .success(jsonObject) = result else {
                return .failure(ResponseObjectSerializationError.requestError)
            }

            guard let json = jsonObject as? JSON else {
                return .failure(
                    ResponseObjectSerializationError.dataSerialization(data: nil))
            }

            do {
                let responseObject = try Object.setup(from: json)
                return .success(responseObject)
            } catch {
                return .failure(error)
            }
        }

        return response(queue: queue, responseSerializer: responseSerializer,
                        completionHandler: completionHandler)
    }

    /// Creates Collection of objects representation of JSON response
    ///
    /// - Parameters:
    ///   - queue: Dispatch queue
    ///   - completionHandler: Completion handler
    /// - Returns: Serialized object on success, error on failure
    func responseObjectsCollection<Object: ResponseObjectSerializable>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<[Object]>) -> Void) -> Self
    {
        let responseSerializer = DataResponseSerializer<[Object]> { request, response, data, error in
            if let error = error { return .failure(error) }

            let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonSerializer.serializeResponse(request, response, data, nil)

            guard case let .success(jsonObject) = result else {
                return .failure(ResponseObjectSerializationError.requestError)
            }

            guard let json = jsonObject as? [JSON] else {
                return .failure(
                    ResponseObjectSerializationError.dataSerialization(data: nil))
            }

            do {
                // Flat map over response objects, once the conversion fails,
                // the response is marked as failed
                let objects = try json.flatMap(Object.setup)
                return .success(objects)
            } catch {
                return .failure(error)
            }
        }

        return response(responseSerializer: responseSerializer,
                        completionHandler: completionHandler)
    }

    /// Creates empty response, used when only response status is needed
    /// not entire body data
    ///
    /// - Parameters:
    ///   - queue: Dispatch queue
    ///   - completionHandler: Completion handler
    /// - Returns: Void response on success, failure with error otherwise
    func responseVoid(queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<Void>) -> Void) -> Self
    {
        let responseSerializer = DataResponseSerializer<Void> { _, _, _, error in
            if let error = error { return .failure(error) }

            return .success(())
        }

        return response(responseSerializer: responseSerializer,
                        completionHandler: completionHandler)
    }
}
