//
//  ConceptViewModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 1/3/2025.
//

import Foundation


class ConceptViewModel: ObservableObject {
    @Published var categories: [ConceptCategory] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadConceptCategories(businessIdeaId: Int) {
        isLoading = true
        errorMessage = nil

        ConceptService.shared.fetchConceptCategories(businessIdeaId: businessIdeaId) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let categories):
                    self.categories = categories
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
