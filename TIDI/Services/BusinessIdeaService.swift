//
//  BusinessIdeaService.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 15/2/2025.
//

import Foundation

struct BusinessIdeaService{
    
    static let shared = BusinessIdeaService()
    
    func fetchBusinessIdeas(completion: @escaping (Result<[BusinessIdea], Error>)-> Void){
        guard let url = URL(string: "\(Constants.baseURL)/businessIdea/all") else { return }
        
        var request = URLRequest(url: url)
        
        // retrive and add the auth token
        if let token = KeychainHelper.shared.getToken(forKey: "userAuthToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(BusinessIdeaResponse.self, from: data)
                completion(.success(decodedResponse.businessIdeas))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Create business idea: API Call
    func createBusinessIdea(businessIdea: BusinessIdeaCreate, completion: @escaping(Result <BusinessIdeaCreateResponse, Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/businessIdea/create") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // retrive and add the auth token
        if let token = KeychainHelper.shared.getToken(forKey: "userAuthToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        //conver to json
        do {
            let jsonData = try JSONEncoder().encode(businessIdea)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Server Error"])))
                return
            }
            
            guard let data = data else { return }
            
            do {
                
                let responseMessage = try JSONDecoder().decode(BusinessIdeaCreateResponse.self, from: data)
                completion(.success(responseMessage))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func fetchSingleBusinessIdeaDetails(business_idea_id: Int, completion: @escaping(Result<BusinessIdea, Error>)-> Void){
        // API Endpoint
        guard let url = URL(string: "\(Constants.baseURL)/businessIdea/\(business_idea_id)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        
        var request = URLRequest(url : url)
        request.httpMethod = "GET"
        
        // retrive and add the auth token
        if let token = KeychainHelper.shared.getToken(forKey: "userAuthToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Network Request
        URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(SingleBusinessIdeaDetailsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse.businessIdea))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
