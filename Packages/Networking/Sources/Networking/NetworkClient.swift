//
//  File.swift
//  
//
//  Created by Markus on 26.03.23.
//

import Foundation

public protocol HTTPClient {
    func execute<T: Decodable>(request: URLRequest, responseType: T.Type) async throws -> T
}

public struct StandardHTTPClient: HTTPClient {

    enum RequestError: Error, Equatable {
        case decoding
        case unexpectedStatusCode(Int)
        case unexpectedResponse
        case unknown
    }

    private let jsonDecoder: JSONDecoder

    public typealias RequestSink = (URLRequest) async throws -> (Data, URLResponse)
    private let requestSink: RequestSink

    public init(
        jsonDecoder: JSONDecoder = JSONDecoder(),
        requestSink: @escaping RequestSink
    ) {
        self.jsonDecoder = jsonDecoder
        self.requestSink = requestSink
    }

    public func execute<T: Decodable>(request: URLRequest, responseType: T.Type) async throws -> T {
        let (data, response) = try await requestSink(request)
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.unexpectedResponse
        }
        // print ("Response: \(response)")

        switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? jsonDecoder.decode(responseType, from: data) else {
                    throw RequestError.decoding
                }

                return decodedResponse

            default:
                throw RequestError.unexpectedStatusCode(response.statusCode)
        }
    }
}
