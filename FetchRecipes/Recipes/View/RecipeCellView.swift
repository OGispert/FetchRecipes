//
//  RecipeCellView.swift
//  FetchRecipes
//
//  Created by Othmar Gispert Sr. on 2/5/25.
//

import SwiftUI
import SwiftData

struct RecipeCellView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var images: [RecipeImage]
    @State private var image = Image(systemName: "carrot.fill")
    @State private var imageData: Data?

    let viewModel: RecipesViewModel
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.headline)
                        .accessibilityAddTraits(.isStaticText)

                    Text("Cuisine: \(recipe.cuisine)")
                        .font(.subheadline)
                        .accessibilityAddTraits(.isStaticText)
                }
                .foregroundColor(.primary)

                Spacer()

                image
                    .resizable()
                    .configImage()
                    .accessibilityAddTraits(.isImage)
            }

            Text("Source: \(recipe.sourceURL ?? "No source available")")
                .font(.caption)
                .padding(.top, 4)
                .accessibilityAddTraits(.isStaticText)
        }
        .onAppear {
            showAndSaveImage(id: recipe.uuid)
        }
        .onChange(of: imageData) { _, data in
            if let data {
                let newImage = RecipeImage(id: recipe.uuid, imageData: data)
                modelContext.insert(newImage)
                try? modelContext.save()
                if let uiImage = UIImage(data: data) {
                    image = Image(uiImage: uiImage)
                }
            }
        }
    }

    private func showAndSaveImage(id: String) {
        withAnimation {
            if let storedImage = images.first(where: { $0.id == id }),
               let uiImage = UIImage(data: storedImage.imageData) {
                image = Image(uiImage: uiImage)
            } else {
                Task {
                    imageData = await viewModel.getImageData(from: recipe.photoURLSmall)
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    RecipeCellView(viewModel: RecipesViewModel(),
                   recipe: Recipe(cuisine: "American",
                                  name: "Banana Pancakes",
                                  photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg",
                                  photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/small.jpg",
                                  sourceURL: "https://www.bbcgoodfood.com/recipes/banana-pancakes",
                                  uuid: "f8b20884-1e54-4e72-a417-dabbc8d91f12",
                                  youtubeURL: "https://www.youtube.com/watch?v=kSKtb2Sv-_U"))
}
#endif
