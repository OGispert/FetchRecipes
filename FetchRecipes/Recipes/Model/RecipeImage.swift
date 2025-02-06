//
//  RecipeImage.swift
//  FetchRecipes
//
//  Created by Othmar Gispert Sr. on 2/5/25.
//

import SwiftUI
import SwiftData

@Model
final class RecipeImage {
    @Attribute(.unique) var id: String
    @Attribute(.externalStorage) var imageData: Data

    init(id: String, imageData: Data) {
        self.id = id
        self.imageData = imageData
    }
}
