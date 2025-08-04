//
//  ResearchModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 6/4/2025.
//

import Foundation

struct ResearchCategory: Identifiable, Codable {
    let id: Int
    let researchId: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "research_cat_id"
        case researchId = "research_id"
        case name = "category_name"
    }
}

struct ResearchCategoryResponse: Codable {
    let progress: Double?
    let businessIdeaId: Int?
    let categories: [ResearchCategory]

    enum CodingKeys: String, CodingKey {
        case progress = "progress"
        case businessIdeaId = "business_idea_id"
        case categories
    }
}


//Research answer response stays under the Research Model

struct ResearchAnswerResponse: Codable {
    let message: String
    let category_name: String
    let answers: [ResearchAnswer]
}

struct ResearchAnswer: Codable, Identifiable {
    let question: String
    var answer: String
    let research_question_id: Int
    let research_id: Int
    let research_cat_id: Int
    let research_answer_id: Int
    
    var id: Int { research_question_id }
    
    // Parse bullet points from the answer string
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
// Main Response Model : Research
struct ResearchTaskResponse: Codable {
    let businessIdeaID: Int
    let researchID: Int
    let tasks: [ResearchTask]
    
    // Map JSON keys to Swift properties (if needed)
    enum CodingKeys: String, CodingKey {
        case businessIdeaID = "business_idea_id"
        case researchID = "research_id"
        case tasks
    }
}

// Task Model
struct ResearchTask: Codable, Identifiable {
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

struct ResearchTaskCompletionResponse: Codable {
    let task_id: Int?
    let message: String
}


// User gen task: Research
struct UserGenResearchTask: Identifiable, Codable {
    let id: Int
    let researchID: Int
    let businessIdeaID: Int
    let taskDescription: String
    let taskStatus: Int // 0 = Incomplete, 1 = Complete

    enum CodingKeys: String, CodingKey {
        case id
        case researchID = "research_id"
        case businessIdeaID = "business_idea_id"
        case taskDescription = "task_description"
        case taskStatus = "task_status"
    }
}

struct UserGenResearchTaskResponse: Codable {
    let message: String
    let task: UserGenResearchTask
}

struct ResearchAnswerEditResponse: Codable {
    let research_answer_id: Int
    let message: String
    let approved_answer: String
}
