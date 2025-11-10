//
//  _NetrofitResponse.swift
//  Netrofit
//
//  Created by Alexandr Valíček on 08.11.2025.
//

import Foundation

public enum _NetrofitResponseError: Error {
    case decodingEmptyDataError
    case statusCodeError(Int)
}

public struct _NetrofitResponse: NetrofitResponse {
    public var request: URLRequest
    public var body: Data?
    public var headers: [String: String]?
    public var statusCode: Int?
    public var error: Error?

    public init(request: URLRequest) {
        self.request = request
    }

    public func validate() throws {
        if let error { throw error }
        if !(200 ..< 300).contains(statusCode ?? -1) {
            throw _NetrofitResponseError.statusCodeError(statusCode ?? -1)
        }
    }
}
