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
