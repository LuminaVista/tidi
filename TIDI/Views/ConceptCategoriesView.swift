//
//  ConceptCategoriesView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 1/3/2025.
//

import SwiftUI

struct ConceptCategoriesView: View {
    @StateObject var viewModel = ConceptViewModel()
    let businessIdeaId: Int
    var body: some View {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.categories, id: \.id) { category in
                                HStack {
                                    Text(category.name)
                                        .font(.headline)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Concept Categories")
            .onAppear {
                viewModel.loadConceptCategories(businessIdeaId: businessIdeaId)
            }
        }
}

#Preview {
    ConceptCategoriesView(businessIdeaId: 20)
}
