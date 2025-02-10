//
//  AuthenticationModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 10/2/2025.
//

import Foundation

struct User: Codable {
    let username: String
    let email: String
    let password: String
}

struct RegisterResponse: Decodable {
    let message: String
}


struct LoginUser: Codable{
    let email: String
    let password: String
}

struct LoginResponse: Codable{
    let message: String
    let token: String
}


