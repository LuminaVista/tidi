//
//  BusinessIdeaViewModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 15/2/2025.
//

import Foundation


class BusinessIdeaViewModel: ObservableObject {
    @Published var businessIdeas: [BusinessIdea] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadBusinessIdeas() {
        isLoading = true
        BusinessIdeaService.shared.fetchBusinessIdeas { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let ideas):
                    self?.businessIdeas = ideas
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch ideas: \(error.localizedDescription)"
                }
            }
        }
    }
}
