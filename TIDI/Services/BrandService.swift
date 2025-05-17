//
//  BrandService.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 17/5/2025.
//

import Foundation

struct BrandService{
    
    
    
    static let shared = BrandService()
    
    func fetchBrandCategories(businessIdeaId: Int, completion:@escaping (Result <BrandCategoryResponse, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/brand/brand_categories/\(businessIdeaId)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Retrieve and add the auth token
        if let token = KeychainHelper.shared.getToken(forKey: "userAuthToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No Data"])))
                return
            }
            
            //            if let jsonString = String(data: data, encoding: .utf8) {
            //                print("API Response JSON: \(jsonString)")
            //            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(BrandCategoryResponse.self, from: data)
                completion(.success(decodedResponse)) // Return full response instead of only categories
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    // AI generated answer service
    func fetchAIAnswers(businessIdeaId: Int, brandCatId: Int, completion: @escaping (Result<BrandAnswerResponse, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/brand/ai/answer/\(businessIdeaId)/\(brandCatId)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // retrieve and add the auth token
        if let token = KeychainHelper.shared.getToken(forKey: "userAuthToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No Data"])))
                return
            }
            
            // for printf debugging
            //                 if let jsonString = String(data: data, encoding: .utf8) {
            //                     print("API Response JSON: \(jsonString)")
            //                 }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(BrandAnswerResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    // AI TASK Generation
    
    // Fetch tasks
    static func fetchTasks(businessIdeaID: Int, completion: @escaping (Result<[BrandTask], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/brand/ai/task/generate/\(businessIdeaID)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // retrieve and add the auth token
        if let token = KeychainHelper.shared.getToken(forKey: "userAuthToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            //            if let jsonString = String(data: data, encoding: .utf8) {
            //                print("📜 API Response JSON: \(jsonString)")
            //            }
            
            do {
                let taskResponse = try JSONDecoder().decode(BrandTaskResponse.self, from: data)
                completion(.success(taskResponse.tasks))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    // Edit Task
    // Mark task as complete
    static func completeTask(businessIdeadID: Int, taskID: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/brand/task/edit/\(businessIdeadID)/\(taskID)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        if let token = KeychainHelper.shared.getToken(forKey: "userAuthToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
                return
            }
            
            // Debugging: Print raw response
            print("Raw Response:", String(data: data, encoding: .utf8) ?? "Invalid Data")
            
            do {
                let responseDict = try JSONDecoder().decode(BrandTaskCompletionResponse.self, from: data)
                if let taskID = responseDict.task_id {
                    completion(.success(taskID))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseDict.message])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // User gen tasks
    func addTask(businessIdeaID: Int, taskDescription: String, completion: @escaping (Result<UserGenBrandTaskResponse, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/brand/task/add/\(businessIdeaID)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = KeychainHelper.shared.getToken(forKey: "userAuthToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let body: [String: Any] = ["task_description": taskDescription]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data received", code: -1)))
                }
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode([String: UserGenBrandTaskResponse].self, from: data)
                if let task = decodedResponse["task"] {
                    DispatchQueue.main.async {
                        completion(.success(task))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "Invalid response format", code: -1)))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

}
