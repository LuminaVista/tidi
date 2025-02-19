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
    
    // BusinessIdea creation related varibables
    @Published var ideaName = ""
    @Published var ideaFoundation = ""
    @Published var problemStatement = ""
    @Published var uniqueSolution = ""
    @Published var targetLocation = ""
    @Published var isLoadingBICreate = false
    @Published var errorMessageBICreate: String?
    @Published var biCreateSuccess: Bool?
    
    
    // load single businessIdea related variables
    @Published var businessIdea: BusinessIdea?
    @Published var isLoadingSingleBusinessDetails = false
    @Published var errorMessageSingleBusinessDetails: String?
    
    func loadBusinessIdeas() {
        isLoading = true
        BusinessIdeaService.shared.fetchBusinessIdeas { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let ideas):
                    self?.businessIdeas = ideas
                case .failure(let error):
                    print("Error loading ideas: \(error)") // Debug print
                    self?.errorMessage = "Failed to fetch ideas: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func submitIdea() {
        let ideaRequest = BusinessIdeaCreate(
            idea_name: ideaName,
            idea_foundation: ideaFoundation,
            problem_statement: problemStatement,
            unique_solution: uniqueSolution,
            target_location: targetLocation
        )
        
        isLoadingBICreate = true
        
        BusinessIdeaService.shared.createBusinessIdea(businessIdea: ideaRequest) { result in
            print(ideaRequest)
            DispatchQueue.main.async {
                self.isLoadingBICreate = false
                
                switch result {
                case .success(let response):
                    self.biCreateSuccess = response.success
                case .failure(let error):
                    self.errorMessageBICreate = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func loadSingleBusinessIdeaDetails(business_idea_id: Int){
        isLoadingSingleBusinessDetails = true
        errorMessageSingleBusinessDetails = nil
        
        BusinessIdeaService.shared.fetchSingleBusinessIdeaDetails(business_idea_id: business_idea_id){ result in
            DispatchQueue.main.async {
                self.isLoadingSingleBusinessDetails = false
                switch result {
                case .success(let idea):
                    self.businessIdea = idea
                case .failure(let error):
                    self.errorMessageSingleBusinessDetails = error.localizedDescription
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
}
