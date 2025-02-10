//
//  AuthenticationService.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 9/2/2025.
//

import Foundation


struct AuthenticationService{
    
    static let shared = AuthenticationService()
    
    func registerUser(user: User, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/users/register") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
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
            guard let data = data else { return }
            
            do {
                // ✅ Decode response expecting a message instead of a User
                let responseMessage = try JSONDecoder().decode(RegisterResponse.self, from: data)
                completion(.success(responseMessage.message))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
