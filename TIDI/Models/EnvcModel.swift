//
//  EnvcModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 9/4/2025.
//

import Foundation

struct EnvcCategory: Identifiable, Codable {
    let id: Int
    let envcId: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "envc_cat_id"
        case envcId = "envc_id"
        case name = "category_name"
    }
}

struct EnvcCategoryResponse: Codable {
    let progress: Double?
    let businessIdeaId: Int?
    let categories: [EnvcCategory]

    enum CodingKeys: String, CodingKey {
        case progress = "progress"
        case businessIdeaId = "business_idea_id"
        case categories
    }
}


//Envc answer response stays under the Envc Model

struct EnvcAnswerResponse: Codable {
    let message: String
    let category_name: String
    let answers: [EnvcAnswer]
}

struct EnvcAnswer: Codable, Identifiable {
    let question: String
    let answer: String
    let envc_question_id: Int
    let envc_id: Int
    let envc_cat_id: Int
    
    var id: Int { envc_question_id }
    
    // Parse bullet points from the answer string
    var bulletPoints: [String] {
        answer.split(separator: "\n")
            .map { String($0) }
            .filter { $0.hasPrefix("- ") }
            .map { String($0.dropFirst(2)) }
    }
}

// TASK RELATED
// Main Response Model : Envc
struct EnvcTaskResponse: Codable {
    let businessIdeaID: Int
    let envcID: Int
    let tasks: [EnvcTask]
    
    // Map JSON keys to Swift properties (if needed)
    enum CodingKeys: String, CodingKey {
        case businessIdeaID = "business_idea_id"
        case envcID = "envc_id"
        case tasks
    }
}

// Task Model
struct EnvcTask: Codable, Identifiable {
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

struct EnvcTaskCompletionResponse: Codable {
    let task_id: Int?
    let message: String
}


// User gen task: Envc
struct UserGenEnvcTask: Identifiable, Codable {
    let id: Int
    let envcID: Int
    let businessIdeaID: Int
    let taskDescription: String
    let taskStatus: Int // 0 = Incomplete, 1 = Complete

    enum CodingKeys: String, CodingKey {
        case id
        case envcID = "envc_id"
        case businessIdeaID = "business_idea_id"
        case taskDescription = "task_description"
        case taskStatus = "task_status"
    }
}

struct UserGenEnvcTaskResponse: Codable {
    let message: String
    let task: UserGenEnvcTask
}

