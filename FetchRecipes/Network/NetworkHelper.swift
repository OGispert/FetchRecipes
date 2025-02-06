//
//  NetworkHelper.swift
//  FetchRecipes
//
//  Created by Othmar Gispert Sr. on 2/5/25.
//

import UIKit

enum Endpoint: String {
    case recipes = "recipes.json"
    case malformed = "recipes-malformed.json"
    case empty = "recipes-empty.json"
}

struct NetworkHelper: NetworkMaker {
    private let session: URLSessionProtocol
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/"

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    /// Method used to retrive info from the web service.
    /// - Parameters:
    ///   - responseModel: The Codable model used to parse the data.
    ///   - endpoint: The last part in the url, to point to different endpoints.
    /// - Returns: The response model.
    func fetch<T: Codable>(responseModel: T.Type, endpoint: Endpoint) async throws -> T {
        var urlString = baseURL
        urlString.append(endpoint.rawValue)

        guard let url = URL(string: urlString) else {
            throw NetworkError(type: .badRequest)
        }

        let request = URLRequest(url: url)
        let (data, response) = try await session.sessionData(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError(type: .responseError)
        }

        if (200...299).contains(httpResponse.statusCode) {
            do {
                return try JSONDecoder().decode(responseModel, from: data)
            } catch {
                let error = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkError(type: .decodingError,
                                   message: error?.message ?? "")
            }
        }
        let error = try? JSONDecoder().decode(ErrorResponse.self, from: data)
        throw NetworkError(type: .responseError,
                           code: httpResponse.statusCode,
                           message: error?.message ?? "There was an unexpected error. Code: \(String(describing: httpResponse.statusCode))")
    }

    /// Method used to fetch the recipe's image from the given URL
    /// - Parameter stringURL: The URL of the image as a `String`
    /// - Returns: The `Data` object
    func downloadImage(from stringURL: String?) async throws -> Data {
        guard let stringURL = stringURL,
              let url = URL(string: stringURL) else {
            throw NetworkError(type: .badRequest)
        }

        do {
            let (data, _) = try await session.sessionData(from: url)
            return data
        } catch {
            throw NetworkError(type: .responseError)
        }
    }
}
