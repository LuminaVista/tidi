//
//  ConceptService.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 1/3/2025.
//

import Foundation


struct ConceptService{
    
    
    static let shared = ConceptService()
    
    func fetchConceptCategories(businessIdeaId: Int, completion:@escaping (Result <[ConceptCategory], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/concept/concept_categories/\(businessIdeaId)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // retrive and add the auth token
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
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("API Response JSON: \(jsonString)")
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(ConceptCategoryResponse.self, from: data)
                completion(.success(decodedResponse.categories))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
