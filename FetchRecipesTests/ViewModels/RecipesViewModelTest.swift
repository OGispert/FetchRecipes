//
//  RecipesViewModelTest.swift
//  FetchRecipesTests
//
//  Created by Othmar Gispert Sr. on 2/6/25.
//

import XCTest
@testable import FetchRecipes

final class RecipesViewModelTest: XCTestCase {

    var viewModel: RecipesViewModel?

    override func setUpWithError() throws {
        viewModel = RecipesViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFecthRecipesSuccess() async {
        // Given
        let mockNetwork = MockNetworkHelper() as NetworkMaker
        viewModel = RecipesViewModel(networkHelper: mockNetwork)
        await viewModel?.fetchRecipes(with: .recipes)

        // When
        let recipes = viewModel?.recipes

        // Then
        XCTAssertNotNil(recipes)
        XCTAssertEqual(recipes?.count, 63)
        XCTAssertFalse(viewModel?.showErrorView ?? true)
        XCTAssertFalse(viewModel?.showEmptyView ?? true)
    }

    func testFecthRecipesMalformed() async {
        // Given
        let mockNetwork = MockNetworkHelper(shouldThrowError: true) as NetworkMaker
        viewModel = RecipesViewModel(networkHelper: mockNetwork)
        
        await viewModel?.fetchRecipes(with: .malformed)

        // When
        let recipes = viewModel?.recipes

        // Then
        XCTAssertTrue(recipes?.isEmpty ?? false)
        XCTAssertTrue(viewModel?.showErrorView ?? false)
    }

    func testFecthRecipesEmpty() async {
        // Given
        let mockNetwork = MockNetworkHelper(shouldShowEmptyData: true) as NetworkMaker
        viewModel = RecipesViewModel(networkHelper: mockNetwork)

        await viewModel?.fetchRecipes(with: .empty)

        // When
        let recipes = viewModel?.recipes

        // Then
        XCTAssertTrue(recipes?.isEmpty ?? false)
        XCTAssertTrue(viewModel?.showEmptyView ?? false)
    }

    func testGetImageData() async {
        // Given
        let mockNetwork = MockNetworkHelper() as NetworkMaker
        viewModel = RecipesViewModel(networkHelper: mockNetwork)

        // When
        let imageData = await viewModel?.getImageData(from: "www.website.com")

        // Then
        XCTAssertNotNil(imageData)
    }

    func testGetImageDataError() async {
        // Given
        let mockNetwork = MockNetworkHelper(shouldThrowError: true) as NetworkMaker
        viewModel = RecipesViewModel(networkHelper: mockNetwork)

        // When
        let imageData = await viewModel?.getImageData(from: "www.website.com")

        // Then
        XCTAssertNil(imageData)
    }

    func testSortRecipesByName() async {
        // Given
        let mockNetwork = MockNetworkHelper() as NetworkMaker
        viewModel = RecipesViewModel(networkHelper: mockNetwork)
        await viewModel?.fetchRecipes(with: .recipes)

        // When
        viewModel?.sortRecipes(sort: .name)

        // Then
        XCTAssertEqual(viewModel?.recipes.first?.name, "Apam Balik")
        XCTAssertEqual(viewModel?.recipes.last?.name, "White Chocolate Crème Brûlée")
    }

    func testSortRecipesByCuisine() async {
        // Given
        let mockNetwork = MockNetworkHelper() as NetworkMaker
        viewModel = RecipesViewModel(networkHelper: mockNetwork)
        await viewModel?.fetchRecipes(with: .recipes)

        // When
        viewModel?.sortRecipes(sort: .cuisine)

        // Then
        XCTAssertEqual(viewModel?.recipes.first?.cuisine, "American")
        XCTAssertEqual(viewModel?.recipes.last?.cuisine, "Tunisian")
    }
}
