//
//  StageModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 28/2/2025.
//

import Foundation

struct Stage: Codable, Identifiable {
    let stage_id: Int
    let stage_name: String
    let progress: Double
    let completed: Int
    let sub_stages: [String]

    var id: Int { stage_id } // Identifiable conformance
}
