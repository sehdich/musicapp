//
//  File.swift
//  
//
//  Created by Markus on 17.03.23.
//

import Foundation

public protocol HTTPClient {
    func execute<T: Decodable>(request: URLRequest, responseType: T.Type) async throws -> T
}

public struct StandardHTTPClient: HTTPClient {

    enum RequestError: Error {
        case decode
        case unexpectedStatusCode
        case unexpectedResponse
        case unknown
    }

    let jsonDecoder: JSONDecoder
    let urlSession: URLSession

    public init(
        jsonDecoder: JSONDecoder = JSONDecoder(),
        urlSession: URLSession = URLSession.shared
    ) {
        self.jsonDecoder = jsonDecoder
        self.urlSession = urlSession
    }

    public func execute<T: Decodable>(request: URLRequest, responseType: T.Type) async throws -> T {
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.unexpectedResponse
            }
            switch response.statusCode {
                case 200...299:
                    guard let decodedResponse = try? jsonDecoder.decode(responseType, from: data) else {
                         throw RequestError.decode
                    }

                    return decodedResponse

                default:
                    throw RequestError.unexpectedStatusCode
            }
        } catch {
            throw RequestError.unknown
        }
    }
}
