//
//  LoginView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 10/2/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appViewModel: AppViewModel // ✅ ADDED
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var navigateToHome = false  // Track navigation state
    

    var body: some View {
        NavigationStack{
            ZStack{
                Color(hex: "#DDD4C8")
                    .ignoresSafeArea()
                
                VStack(spacing: 20){
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    CustomTextField(placeholder: "Email", text: $loginViewModel.email)
                    CustomTextField(placeholder: "Password", text: $loginViewModel.password, isSecure: true)
                    
                    if let errorMessage = loginViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.horizontal)
                    }
                    if loginViewModel.isLoading { 
                        ProgressView()
                            .padding()
                    }
                    
                    Button(action: {
                        navigateToHome = false
                        loginViewModel.login()
                    }) {
                        Text("Let's get started ")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color(hex: "#C8DCD8"))
                            .foregroundColor(.black)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal)
                    .disabled(loginViewModel.isLoading)
                    
                    Button(action: {
                        loginViewModel.errorMessage = nil
                    }) {
                        NavigationLink("Forgot Password?", destination: ResetPasswordView())
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    
                    Image("tidi_sun")  // Add your logo to Assets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                }
                // ✅ MODIFIED: This updates global login state when user logs in
                .onChange(of: loginViewModel.isLoggedIn) {
                    if loginViewModel.isLoggedIn {
                        appViewModel.isLoggedIn = true
                        appViewModel.markFirstLaunchComplete() // ✅ ADD THIS LINE
                        navigateToHome = true
                    }
                }
                .onChange(of: navigateToHome) {
                    if !navigateToHome {
                        loginViewModel.email = ""
                        loginViewModel.password = ""
                        loginViewModel.errorMessage = nil
                        loginViewModel.isLoggedIn = false
                    }
                }
            }
            // ✅ MODIFIED: Uses global logout and resets state
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView(
                    onLogout: {
                        appViewModel.logout() // ✅ NEW: Clears Keychain + login state
                        navigateToHome = false
                    }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}



#Preview {
    LoginView()
        .environmentObject(AppViewModel())
}
