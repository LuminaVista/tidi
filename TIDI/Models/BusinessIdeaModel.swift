//
//  BusinessIdeaModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 15/2/2025.
//

import Foundation

struct BusinessIdea: Codable, Identifiable {
    let business_idea_id: Int
    let user_id: Int
    let idea_name: String
    let idea_foundation: String
    let problem_statement: String
    let unique_solution: String
    let target_location: String
    let created_at: String
    let isActive: Int
    let idea_progress: Double
    
    var id: Int { business_idea_id } // Identifiable conformance
}

struct BusinessIdeaResponse: Codable {
    let businessIdeas: [BusinessIdea]
}

struct BusinessIdeaCreate: Codable {
    let idea_name: String
    let idea_foundation: String
    let problem_statement: String
    let unique_solution: String
    let target_location: String
}

struct BusinessIdeaCreateResponse: Codable{
    let message: String
    let success: Bool
}

struct SingleBusinessIdeaDetailsResponse: Codable {
    let businessIdea: BusinessIdea
}
