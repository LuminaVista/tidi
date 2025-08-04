//
//  BudgetModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 9/4/2025.
//

import Foundation

struct BudgetCategory: Identifiable, Codable {
    let id: Int
    let budgetId: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "budget_cat_id"
        case budgetId = "budget_id"
        case name = "category_name"
    }
}

struct BudgetCategoryResponse: Codable {
    let progress: Double?
    let businessIdeaId: Int?
    let categories: [BudgetCategory]

    enum CodingKeys: String, CodingKey {
        case progress = "progress"
        case businessIdeaId = "business_idea_id"
        case categories
    }
}

//Budget answer response stays under the Budget Model

struct BudgetAnswerResponse: Codable {
    let message: String
    let category_name: String
    let answers: [BudgetAnswer]
}

struct BudgetAnswer: Codable, Identifiable {
    let question: String
    var answer: String
    let budget_question_id: Int
    let budget_id: Int
    let budget_cat_id: Int
    let budget_answer_id: Int
    
    var id: Int { budget_question_id }
    
    // Parse bullet points from the answer string
    var bulletPoints: [String] {
        let lines = answer.split(separator: "\n")
            .map { String($0) }
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        let bulletPointLines = lines.filter { $0.hasPrefix("- ") }
            .map { String($0.dropFirst(2)) }
        
        // If bullet points exist, return them
        if !bulletPointLines.isEmpty {
            return bulletPointLines
        }
        
        // If no bullet points found, return the entire answer as a single item
        let trimmedAnswer = answer.trimmingCharacters(in: .whitespaces)
        return trimmedAnswer.isEmpty ? [] : [trimmedAnswer]
    }
}


// TASK RELATED
// Main Response Model : Budget
struct BudgetTaskResponse: Codable {
    let businessIdeaID: Int
    let budgetID: Int
    let tasks: [BudgetTask]
    
    // Map JSON keys to Swift properties (if needed)
    enum CodingKeys: String, CodingKey {
        case businessIdeaID = "business_idea_id"
        case budgetID = "budget_id"
        case tasks
    }
}

// Task Model
struct BudgetTask: Codable, Identifiable {
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

struct BudgetTaskCompletionResponse: Codable {
    let task_id: Int?
    let message: String
}


// User gen task: Budget
struct UserGenBudgetTask: Identifiable, Codable {
    let id: Int
    let budgetID: Int
    let businessIdeaID: Int
    let taskDescription: String
    let taskStatus: Int // 0 = Incomplete, 1 = Complete

    enum CodingKeys: String, CodingKey {
        case id
        case budgetID = "budget_id"
        case businessIdeaID = "business_idea_id"
        case taskDescription = "task_description"
        case taskStatus = "task_status"
    }
}

struct UserGenBudgetTaskResponse: Codable {
    let message: String
    let task: UserGenBudgetTask
}

// Response model for edit/approve
struct BudgetAnswerEditResponse: Codable {
    let budget_answer_id: Int
    let message: String
    let approved_answer: String
}
