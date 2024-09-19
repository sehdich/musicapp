@testable import Networking
import XCTest
// COmment
final class NetworkingTests: XCTestCase {

    func testUnexpectedResponseError() async throws {
        let urlResponse = URLResponse()
        let client = StandardHTTPClient { _ in
            (Data(), urlResponse)
        }
        let request = URLRequest(url: URL(string: "http://www.google.com")!)

        do {
            _ = try await client.execute(request: request, responseType: String.self)
            XCTFail("An error is expected to be thrown")
        } catch {
            XCTAssertEqual(error as? StandardHTTPClient.RequestError, .unexpectedResponse)
        }
    }

    func testDecodingError() async throws {
        let urlResponse = HTTPURLResponse()
        let jsonData =
        """
        {
            "items": ["test", "foo"]
        }
        """.data(using: .utf8)!

        let client = StandardHTTPClient { _ in
            (jsonData, urlResponse)
        }
        let request = URLRequest(url: URL(string: "http://www.google.com")!)

        do {
            _ = try await client.execute(request: request, responseType: String.self)
            XCTFail("An error is expected to be thrown")
        } catch {
            XCTAssertEqual(error as? StandardHTTPClient.RequestError, .decoding)
        }
    }

    func testUnexpectedHTTPStatusCode() async throws {
        let url = URL(string: "http://www.google.com")!
        let httpStatusCode: Int = 500
        let urlResponse = HTTPURLResponse(url: url, statusCode: httpStatusCode, httpVersion: nil, headerFields: nil)!

        let client = StandardHTTPClient { _ in
            (Data(), urlResponse)
        }
        let request = URLRequest(url: url)

        do {
            _ = try await client.execute(request: request, responseType: String.self)
            XCTFail("An error is expected to be thrown")
        } catch {
            XCTAssertEqual(error as? StandardHTTPClient.RequestError, .unexpectedStatusCode(httpStatusCode))
        }
    }
}
