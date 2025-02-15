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
    
    
    
    
}
