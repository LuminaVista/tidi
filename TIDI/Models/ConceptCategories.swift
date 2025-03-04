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
    let progress: Double?
    let businessIdeaId: Int?
    let categories: [ConceptCategory]

    enum CodingKeys: String, CodingKey {
        case progress = "progress"
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

// TASK RELATED
// Main Response Model
struct TaskResponse: Codable {
    let businessIdeaID: Int
    let conceptID: Int
    let tasks: [Task]
    
    // Map JSON keys to Swift properties (if needed)
    enum CodingKeys: String, CodingKey {
        case businessIdeaID = "business_idea_id"
        case conceptID = "concept_id"
        case tasks
    }
}

// Task Model
struct Task: Codable, Identifiable {
    let id: Int
    let taskDescription: String
    let taskStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case taskDescription = "task_description"
        case taskStatus = "task_status"
    }
    
    // Convert task_status from Int (0/1) to Bool
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        taskDescription = try container.decode(String.self, forKey: .taskDescription)
        let statusInt = try container.decode(Int.self, forKey: .taskStatus)
        taskStatus = statusInt == 1 // Convert 0 to false, 1 to true
    }
    
    // Convert Bool to Int when encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(taskDescription, forKey: .taskDescription)
        try container.encode(taskStatus ? 1 : 0, forKey: .taskStatus)
    }
}

struct TaskCompletionResponse: Codable {
    let task_id: Int?
    let message: String
}
