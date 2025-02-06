//
//  View+Extensions.swift
//  FetchRecipes
//
//  Created by Othmar Gispert Sr. on 2/6/25.
//

import SwiftUI

extension View {

    /// Extension modifier to be able to apply modifiers conditionally.
    /// - Parameters:
    ///   - conditional: The condition to evaluate
    ///   - content: The content of the view including the modifiers.
    /// - Returns: The same view applying the modifiers or the same view unaltered.
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        }
        return AnyView(self)
    }
}
