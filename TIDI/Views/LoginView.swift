//
//  LoginView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 10/2/2025.
//

import SwiftUI

struct LoginView: View {
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
                    
                    Image("tidi_sun")  // Add your logo to Assets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    
                }
                .onChange(of: loginViewModel.isLoggedIn){
                    if loginViewModel.isLoggedIn{
                        navigateToHome = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()  // Navigate to HomeView when logged in
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}



#Preview {
    LoginView()
}
