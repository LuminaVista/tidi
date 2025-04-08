//
//  LoginViewModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 10/2/2025.
//

import Foundation

class LoginViewModel: ObservableObject{
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading: Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?
    
    func login(){
        
        isLoading = true
        
        guard !email.isEmpty, !password.isEmpty else{
            self.errorMessage = ErrorMessages.FieldRequired.fieldsRequired
            return
        }
        
        let loginUser = LoginUser(email: email, password: password)
        
        AuthenticationService.shared.loginUser(loginuser: loginUser) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result{
                case .success(let response):
                    print("Login Successfull!: \(response.token)")
                    KeychainHelper.shared.saveToken(response.token, forKey: "userAuthToken")
                    self?.isLoggedIn = true
                case .failure(let error):
                    print("Login Failed: \(error.localizedDescription)")
                    if (error as NSError).code == 401 {
                        self?.showErrorMessage("Invalid email or password. Please try again.")
                    }
                    else if (error as NSError).code == 404{
                        self?.showErrorMessage("User not found. Please provide valid email.")
                    }
                    else {
                        self?.showErrorMessage("Something went wrong. Please check your connection.")
                    }
                }
            }
            
        }
    }
    
    /// Displays an error message and removes it after 2 seconds
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.errorMessage = nil
        }
    }
    
    func logout() {
        // Remove token from Keychain
        KeychainHelper.shared.deleteToken(forKey: "userAuthToken")
        
        // Set login state to false
        isLoggedIn = false
    }
    
    
}
