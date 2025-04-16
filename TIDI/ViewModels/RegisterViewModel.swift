//
//  RegisterViewModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 10/2/2025.
//

import Foundation

class RegisterViewModel: ObservableObject{
    
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isRegistered = false
    @Published var errorMessage: String?
    
    func register(){
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else{
            self.errorMessage = ErrorMessages.FieldRequired.fieldsRequired
            return
        }
        
        guard password.count >= 8 else {
            self.errorMessage = ErrorMessages.Auth.passwordTooShort
            return
        }
        
        let newUser = User(username: username, email: email, password: password)
        
        AuthenticationService.shared.registerUser(user: newUser) { result in
            DispatchQueue.main.async {
                switch result{
                case .success:
                    print("Registration Successfull!")
                    self.isRegistered = true
                case .failure(let error):
                    print("Registration Failed: ", error.localizedDescription)
                    self.errorMessage = error.localizedDescription
                }
            }
            
        }
    }
    
    
}
