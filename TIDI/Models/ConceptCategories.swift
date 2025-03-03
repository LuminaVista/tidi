//
//  ConceptCategories.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 1/3/2025.
//

import Foundation

struct ConceptCategory: Identifiable, Codable {
    let id: Int
    let conceptId: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "concept_cat_id"
        case conceptId = "concept_id"
        case name = "category_name"
    }
}

struct ConceptCategoryResponse: Codable {
    let businessIdeaId: Int?
    let categories: [ConceptCategory]

    enum CodingKeys: String, CodingKey {
        case businessIdeaId = "business_idea_id"
        case categories
    }
}

//concept answer response stays under the concept categories

struct ConceptAnswerResponse: Codable {
    let message: String
    let category_name: String
    let answers: [ConceptAnswer]
}

struct ConceptAnswer: Codable, Identifiable {
    let question: String
    let answer: String
    let concept_question_id: Int
    let concept_id: Int
    let concept_cat_id: Int
    
    var id: Int { concept_question_id }
    
    // Parse bullet points from the answer string
    var bulletPoints: [String] {
        answer.split(separator: "\n")
            .map { String($0) }
            .filter { $0.hasPrefix("- ") }
            .map { String($0.dropFirst(2)) }
    }
}
