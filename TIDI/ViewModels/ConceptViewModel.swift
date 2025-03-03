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
    
    // For AI answers
    @Published var answers: [ConceptAnswer] = []
    @Published var categoryName: String = ""
    @Published var isLoadingAnswers = false
    @Published var answersErrorMessage: String?
    
    
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
    
    
    // ai generated answer view model
    func loadAIAnswers(businessIdeaId: Int, conceptCatId: Int) {
        isLoadingAnswers = true
        answersErrorMessage = nil
        
        ConceptService.shared.fetchAIAnswers(businessIdeaId: businessIdeaId, conceptCatId: conceptCatId) { result in
            DispatchQueue.main.async {
                self.isLoadingAnswers = false
                switch result {
                case .success(let response):
                    self.categoryName = response.category_name
                    self.answers = response.answers
                case .failure(let error):
                    self.answersErrorMessage = error.localizedDescription
                }
            }
        }
    }
}
