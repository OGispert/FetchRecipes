//
//  ImageViewModifier.swift
//  FetchRecipes
//
//  Created by Othmar Gispert Sr. on 2/5/25.
//

import SwiftUI

struct ImageViewModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: 80, height: 80)
            .background(Color.gray)
            .clipShape(Circle())
    }
}

extension View {

    /// View modifier to apply common modifiers to an Image View
    /// - Returns: The Image view
    func configImage() -> some View {
        modifier(ImageViewModifier())
    }
}

