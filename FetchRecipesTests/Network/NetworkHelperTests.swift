//
//  NetworkHelperTests.swift
//  FetchRecipesTests
//
//  Created by Othmar Gispert Sr. on 2/5/25.
//

import XCTest
@testable import FetchRecipes

final class NetworkHelperTests: XCTestCase {
    var network: NetworkHelper?

    override func tearDownWithError() throws {
        network = nil
    }

    func testFetchRecipesSuccess() throws {
        // Given
        let expectation = self.expectation(description: "fetchRecipes")
        var recipes: RecipesResponse?
        network = NetworkHelper(session: MockURLSession(mockFile: "Recipes"))

        // When
        Task {
            recipes = try await network?.fetch(responseModel: RecipesResponse.self, endpoint: .recipes)
            expectation.fulfill()
        }
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertFalse(recipes?.recipes?.isEmpty ?? true)
    }

    func testFetchRecipesMalformed() throws {
        // Given
        let expectation = self.expectation(description: "fetchRecipes")
        var recipes: RecipesResponse?
        network = NetworkHelper(session: MockURLSession(mockFile: "RecipesMalformed"))

        // When
        Task {
            do {
                recipes = try await network?.fetch(responseModel: RecipesResponse.self, endpoint: .malformed)
            } catch {
                expectation.fulfill()
            }
        }
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(recipes?.recipes)
    }

    func testFetchRecipesEmpty() throws {
        // Given
        let expectation = self.expectation(description: "fetchRecipes")
        var recipes: RecipesResponse?
        network = NetworkHelper(session: MockURLSession(mockFile: "RecipesEmpty"))

        // When
        Task {
            recipes = try await network?.fetch(responseModel: RecipesResponse.self, endpoint: .empty)
            expectation.fulfill()
        }
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(recipes?.recipes?.isEmpty ?? false)
    }

    func testDownloadImageSuccess() async throws {
        // Given
        network = NetworkHelper(session: MockURLSession(mockFile: "Recipes"))

        // When
        let image = try await network?.downloadImage(from: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")

        // Then
        XCTAssertNotNil(image)
    }

    func testDownloadImageError() async throws {
        // Given
        network = NetworkHelper(session: MockURLSession(mockFile: "Recipes",
                                                        isResponseError: true))

        // When
        do {
            _ = try await network?.downloadImage(from: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320")
        } catch {
            // Then
            XCTAssertTrue(error is NetworkError)
            XCTAssertEqual((error as? NetworkError)?.type, .responseError)
        }
    }
}
