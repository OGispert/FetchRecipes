//
//  URLSession.swift
//  FetchRecipes
//
//  Created by Othmar Gispert Sr. on 2/5/25.
//

import Foundation

/// Adding this protocol to be able to add test cases to our `NetworkHelper`,
/// mocking the `URLSession`
protocol URLSessionProtocol {
    func sessionData(for request: URLRequest) async throws -> (Data, URLResponse)
    func sessionData(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    func sessionData(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await self.data(for: request)
    }

    func sessionData(from url: URL) async throws -> (Data, URLResponse) {
        try await self.data(from: url)
    }
}
