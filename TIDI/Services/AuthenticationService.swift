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
            
            // Ensure we have a valid HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 409 {
                    // Handle Unauthorized login
                    let authError = NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "Email already registered. Please login with the email."])
                    completion(.failure(authError))
                    return
                }
                
            }
            
            
            guard let data = data else { return }
            
            do {
                let responseMessage = try JSONDecoder().decode(RegisterResponse.self, from: data)
                completion(.success(responseMessage.message))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func loginUser(loginuser: LoginUser, completion: @escaping (Result<LoginResponse, Error>)-> Void){
        guard let url = URL(string: "\(Constants.baseURL)/users/login") else {return}
        
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(loginuser)
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
            
            
            // Ensure we have a valid HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 401 {
                    // Handle Unauthorized login
                    let authError = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid email or password."])
                    completion(.failure(authError))
                    return
                }
                if httpResponse.statusCode == 404 {
                    // User Not Found
                    let authError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "User Not Found"])
                    completion(.failure(authError))
                    return
                }
            }
            
            
            guard let data = data else { return }
            
            do {
                
                let responseMessage = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(.success(responseMessage))
            } catch {
                completion(.failure(error))
            }
        }.resume()
        
        
    }
    
    
    // forgot password
    func sendResetEmail(to email: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/rp/forgot-password") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let payload = ["email": email]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            } catch {
                completion(.failure(error))
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data,
                      let responseObj = try? JSONDecoder().decode([String: String].self, from: data),
                      let message = responseObj["message"] else {
                    completion(.failure(NSError(domain: "Invalid response", code: 1)))
                    return
                }

                completion(.success(message))
            }.resume()
        }
    
    
    
    
    
    
}
