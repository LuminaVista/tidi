//
//  MarketingModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 7/4/2025.
//

import Foundation

struct MarketingCategory: Identifiable, Codable {
    let id: Int
    let marketingId: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "marketing_cat_id"
        case marketingId = "marketing_id"
        case name = "category_name"
    }
}

struct MarketingCategoryResponse: Codable {
    let progress: Double?
    let businessIdeaId: Int?
    let categories: [MarketingCategory]

    enum CodingKeys: String, CodingKey {
        case progress = "progress"
        case businessIdeaId = "business_idea_id"
        case categories
    }
}

//Marketing answer response stays under the Marketing Model

struct MarketingAnswerResponse: Codable {
    let message: String
    let category_name: String
    let answers: [MarketingAnswer]
}

struct MarketingAnswer: Codable, Identifiable {
    let question: String
    let answer: String
    let marketing_question_id: Int
    let marketing_id: Int
    let marketing_cat_id: Int
    
    var id: Int { marketing_question_id }
    
    // Parse bullet points from the answer string
    var bulletPoints: [String] {
        answer.split(separator: "\n")
            .map { String($0) }
            .filter { $0.hasPrefix("- ") }
            .map { String($0.dropFirst(2)) }
    }
}

// TASK RELATED
// Main Response Model : Marketing
struct MarketingTaskResponse: Codable {
    let businessIdeaID: Int
    let marketingID: Int
    let tasks: [MarketingTask]
    
    // Map JSON keys to Swift properties (if needed)
    enum CodingKeys: String, CodingKey {
        case businessIdeaID = "business_idea_id"
        case marketingID = "marketing_id"
        case tasks
    }
}

// Task Model
struct MarketingTask: Codable, Identifiable {
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

struct MarketingTaskCompletionResponse: Codable {
    let task_id: Int?
    let message: String
}


// User gen task: Marketing
struct UserGenMarketingTask: Identifiable, Codable {
    let id: Int
    let marketingID: Int
    let businessIdeaID: Int
    let taskDescription: String
    let taskStatus: Int // 0 = Incomplete, 1 = Complete

    enum CodingKeys: String, CodingKey {
        case id
        case marketingID = "marketing_id"
        case businessIdeaID = "business_idea_id"
        case taskDescription = "task_description"
        case taskStatus = "task_status"
    }
}

struct UserGenMarketingTaskResponse: Codable {
    let message: String
    let task: UserGenMarketingTask
}
