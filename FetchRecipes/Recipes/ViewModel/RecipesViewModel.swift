//
//  RecipesViewModel.swift
//  FetchRecipes
//
//  Created by Othmar Gispert Sr. on 2/5/25.
//

import Foundation

@MainActor
@Observable
final class RecipesViewModel {
    var recipes: [Recipe] = []
    var sort: SortOptions = .name
    var showTestAlert = false
    var showErrorView = false
    var showEmptyView = false

    private let networkHelper: NetworkMaker
    private(set) var isRefreshing = false

    init(networkHelper: NetworkMaker = NetworkHelper()) {
        self.networkHelper = networkHelper
    }

    func fetchRecipes(with endpoint: Endpoint) async {
        isRefreshing = true
        defer {
            isRefreshing = false
        }

        do {
            try await Task.sleep(for: .seconds(2))
            let recipesData = try await networkHelper.fetch(responseModel: RecipesResponse.self,
                                                            endpoint: endpoint)
            guard let recipes = recipesData.recipes, !recipes.isEmpty else {
                self.recipes = []
                showEmptyView = true
                return
            }
            showEmptyView = false
            showErrorView = false
            self.recipes = recipes.sorted(using: KeyPathComparator(\.name, comparator: .localizedStandard))
        } catch {
            self.recipes = []
            showErrorView = true
        }
    }

    func getImageData(from imageUrl: String?) async -> Data? {
        do {
            return try await networkHelper.downloadImage(from: imageUrl)
        } catch {
            return nil
        }
    }

    func sortRecipes(sort: SortOptions) {
        switch sort {
        case .name:
            recipes = recipes.sorted(using: KeyPathComparator(\.name, comparator: .localizedStandard))

        case .cuisine:
            recipes = recipes.sorted(using: KeyPathComparator(\.cuisine, comparator: .localizedStandard))
        }
    }
}
