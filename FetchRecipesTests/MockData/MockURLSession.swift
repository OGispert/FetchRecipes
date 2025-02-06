//
//  MockURLSession.swift
//  FetchRecipes
//
//  Created by Othmar Gispert Sr. on 2/6/25.
//

@testable import FetchRecipes
import Foundation

class MockURLSession: URLSessionProtocol {
    private let mockFile: String
    private let isResponseError: Bool

    init(mockFile: String, isResponseError: Bool = false) {
        self.mockFile = mockFile
        self.isResponseError = isResponseError
    }

    func sessionData(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard let requestURL = request.url else {
            throw NetworkError(type: .badRequest)
        }
        let mockResponse = HTTPURLResponse(url: requestURL, statusCode: isResponseError ? 404 : 200, httpVersion: nil, headerFields: nil)!
        let url = Bundle.main.url(forResource: mockFile, withExtension: "json")
        let mockData = try Data(contentsOf: url!)
        if isResponseError {
            throw NetworkError(type: .responseError, code: 404)
        } else {
            return (mockData, mockResponse)}
    }

    func sessionData(from url: URL) async throws -> (Data, URLResponse) {
        let mockResponse = HTTPURLResponse(url: url, statusCode: isResponseError ? 404 : 200, httpVersion: nil, headerFields: nil)!
        if isResponseError {
            throw NetworkError(type: .responseError, code: 404)
        } else {
            return (Data(), mockResponse)
        }
    }
}
