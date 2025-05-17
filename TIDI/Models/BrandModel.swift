//
//  BrandModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 17/5/2025.
//

import Foundation

struct BrandCategory: Identifiable, Codable {
    let id: Int
    let brandId: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "brand_cat_id"
        case brandId = "brand_id"
        case name = "category_name"
    }
}


struct BrandCategoryResponse: Codable {
    let progress: Double?
    let businessIdeaId: Int?
    let categories: [BrandCategory]

    enum CodingKeys: String, CodingKey {
        case progress = "progress"
        case businessIdeaId = "business_idea_id"
        case categories
    }
}


//Brand answer response stays under the Brand Model
struct BrandAnswerResponse: Codable {
    let message: String
    let category_name: String
    let answers: [BrandAnswer]
}

struct BrandAnswer: Codable, Identifiable {
    let question: String
    let answer: String
    let brand_question_id: Int
    let brand_id: Int
    let brand_cat_id: Int
    
    var id: Int { brand_question_id }
    
    // Parse bullet points from the answer string
    var bulletPoints: [String] {
        answer.split(separator: "\n")
            .map { String($0) }
            .filter { $0.hasPrefix("- ") }
            .map { String($0.dropFirst(2)) }
    }
}


// TASK RELATED
// Main Response Model : Brand
struct BrandTaskResponse: Codable {
    let businessIdeaID: Int
    let brandID: Int
    let tasks: [BrandTask]
    
    // Map JSON keys to Swift properties (if needed)
    enum CodingKeys: String, CodingKey {
        case businessIdeaID = "business_idea_id"
        case brandID = "brand_id"
        case tasks
    }
}


// Task Model
struct BrandTask: Codable, Identifiable {
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


struct BrandTaskCompletionResponse: Codable {
    let task_id: Int?
    let message: String
}


// User gen task: Brand
struct UserGenBrandTask: Identifiable, Codable {
    let id: Int
    let brandID: Int
    let businessIdeaID: Int
    let taskDescription: String
    let taskStatus: Int // 0 = Incomplete, 1 = Complete

    enum CodingKeys: String, CodingKey {
        case id
        case brandID = "brand_id"
        case businessIdeaID = "business_idea_id"
        case taskDescription = "task_description"
        case taskStatus = "task_status"
    }
}

struct UserGenBrandTaskResponse: Codable {
    let message: String
    let task: UserGenBrandTask
}
