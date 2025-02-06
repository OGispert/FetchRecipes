//
//  FetchRecipesApp.swift
//  FetchRecipes
//
//  Created by Othmar Gispert Sr. on 2/5/25.
//

import SwiftUI
import SwiftData

@main
struct FetchRecipesApp: App {
    var body: some Scene {
        WindowGroup {
            RecipesView(viewModel: RecipesViewModel())
        }
        .modelContainer(for: [RecipeImage.self])
    }
}
