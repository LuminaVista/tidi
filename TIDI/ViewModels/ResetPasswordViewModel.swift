//
//  ResetPasswordViewModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 31/3/2025.
//

import Foundation

class ResetPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var successMessage: String?
    @Published var errorMessage: String?
    @Published var navigateToLogin: Bool = false

    func sendResetRequest() {
        guard !email.isEmpty else {
            errorMessage = "Email can't be empty"
            return
        }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        AuthenticationService.shared.sendResetEmail(to: email) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let message):
                    self.successMessage = message
                    self.navigateToLogin = true
                    print(message)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
