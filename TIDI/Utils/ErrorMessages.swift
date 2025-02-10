//
//  ErrorMessages.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 10/2/2025.
//


import Foundation

struct ErrorMessages {
    struct Auth {
        static let invalidEmail = "Please enter a valid email address."
        static let passwordTooShort = "Password must be at least 8 characters long."
        static let userNotFound = "User not found. Please check your credentials."
    }
    
    struct Network {
        static let requestFailed = "Network request failed. Please check your internet connection."
        static let serverError = "Server error. Please try again later."
    }
    
    struct General {
        static let unknownError = "Something went wrong. Please try again."
    }
    
    struct FieldRequired{
        static let fieldsRequired = "All the fields are required."
    }
}
