//
//  RecipesView.swift
//  FetchRecipes
//
//  Created by Othmar Gispert Sr. on 2/5/25.
//

import SwiftUI

struct RecipesView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Bindable var viewModel: RecipesViewModel

    var body: some View {
        NavigationStack {
            List($viewModel.recipes, id: \.uuid, editActions: .all) { $recipe in
                RecipeCellView(viewModel: viewModel, recipe: recipe)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 5)
                            .background(.clear)
                            .foregroundColor(colorScheme == .dark ? Color(UIColor.darkGray) : .white)
                    )
                    .listRowSeparator(.hidden)
            }
            .if(viewModel.showEmptyView) { $0.hidden() }
            .listRowSpacing(16)
            .redacted(reason: viewModel.isRefreshing ? .placeholder : [])
            .refreshable {
                fetchRecipes(.recipes)
                viewModel.sort = .name
            }
            .navigationTitle(viewModel.showEmptyView ? "" : "Recipes")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        viewModel.showTestAlert = true
                    } label: {
                        Text("Test")
                    }
                    .accessibilityAddTraits(.isButton)
                }
            }
            .toolbar {
                Menu {
                    Picker("Sort", selection: $viewModel.sort) {
                        ForEach(SortOptions.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                } label: {
                    Label("Sort",
                          systemImage: "arrow.up.and.down.text.horizontal")
                }
                .disabled(viewModel.showEmptyView)
                .accessibilityAddTraits(.isButton)
            }
            .onChange(of: viewModel.sort) { _, newValue in
                viewModel.sortRecipes(sort: newValue)
            }
        }
        .overlay {
            if viewModel.showEmptyView {
                EmptyResponseView {
                    fetchRecipes(.recipes)
                }
            }
        }
        .onAppear {
            fetchRecipes(.recipes)
        }
        .alert("Select the response you want to test.", isPresented: $viewModel.showTestAlert) {
            Button("Success response") {
                fetchRecipes(.recipes)
            }
            .accessibilityAddTraits(.isButton)
            Button("Error response") {
                fetchRecipes(.malformed)
            }
            .accessibilityAddTraits(.isButton)
            Button("Empty response") {
                fetchRecipes(.empty)
            }
            .accessibilityAddTraits(.isButton)
        }
        .alert("Oops!", isPresented: $viewModel.showErrorView) {
            Button("Cancel", role: .destructive) { viewModel.showEmptyView = true }
                .accessibilityAddTraits(.isButton)
            Button("Refresh now", role: .cancel) { fetchRecipes(.recipes) }
                .accessibilityAddTraits(.isButton)
        } message: {
            Text("There was an error fetching the data. Please try again later.")
                .accessibilityAddTraits(.isStaticText)
        }
    }

    private func fetchRecipes(_ endpoint: Endpoint) {
        Task {
            await viewModel.fetchRecipes(with: endpoint)
        }
    }
}

#if DEBUG
#Preview {
    RecipesView(viewModel: RecipesViewModel())
}
#endif
