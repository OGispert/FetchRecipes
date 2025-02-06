//
//  MockNetworkHelper.swift
//  FetchRecipes
//
//  Created by Othmar Gispert Sr. on 2/6/25.
//


@testable import FetchRecipes
import Foundation

struct MockNetworkHelper: NetworkMaker {
    var shouldThrowError = false
    var shouldShowEmptyData = false

    func fetch<T: Codable>(responseModel: T.Type, endpoint: Endpoint) async throws -> T {
        do {
            if shouldThrowError {
                let data = try await mockErrorResponse()
                return try JSONDecoder().decode(responseModel.self, from: data)
            } else if shouldShowEmptyData {
                let data = try await mockEmptyResponse()
                return try JSONDecoder().decode(responseModel.self, from: data)
            } else {
                let data = try await mockSuccessResponse()
                return try JSONDecoder().decode(responseModel.self, from: data)
            }
        } catch {
            throw NetworkError(type: .responseError)
        }
    }

    func downloadImage(from stringURL: String?) async throws -> Data {
        if shouldThrowError {
            throw NetworkError(type: .responseError)
        } else {
            mockImageData()
        }
    }

    private func mockSuccessResponse() async throws -> Data {
        do {
            let url = Bundle.main.url(forResource: "Recipes", withExtension: "json")
            return try Data(contentsOf: url!)
        } catch {
            throw NetworkError(type: .responseError)
        }
    }

    private func mockErrorResponse() async throws -> Data {
        do {
            let url = Bundle.main.url(forResource: "RecipesMalformed", withExtension: "json")
            return try Data(contentsOf: url!)
        } catch {
            throw NetworkError(type: .responseError)
        }
    }
    
    private func mockEmptyResponse() async throws -> Data {
        do {
            let url = Bundle.main.url(forResource: "RecipesEmpty", withExtension: "json")
            return try Data(contentsOf: url!)
        } catch {
            throw NetworkError(type: .responseError)
        }
    }

    private func mockImageData() -> Data {
        Data()
    }
}
