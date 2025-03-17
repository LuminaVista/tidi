//
//  RegisterView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 9/2/2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var registerViewModel = RegisterViewModel()
    @State private var navigateToLogin = false // Track navigation
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(hex: "#DDD4C8")
                    .ignoresSafeArea()
                
                VStack(spacing: 20){
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    CustomTextField(placeholder: "Email", text: $registerViewModel.email)
                    CustomTextField(placeholder: "Username", text: $registerViewModel.username)
                    CustomTextField(placeholder: "Password", text: $registerViewModel.password, isSecure: true)
                    
                    
                    if let errorMessage = registerViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.horizontal)
                    }
                    
                    
                    Button(action: {
                        registerViewModel.register()
                    }) {
                        Text("Get started")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color(hex: "#C8DCD8"))
                            .foregroundColor(.black)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal)
                    .disabled(registerViewModel.username.isEmpty || registerViewModel.email.isEmpty || registerViewModel.password.isEmpty)
                    
                    // Normal text + NavigationLink for "Log in"
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.black.opacity(0.7))
                        
                        NavigationLink(destination: LoginView()) {
                            Text("Log in")
                                .foregroundColor(.blue)
                                .fontWeight(.bold)
                        }
                    }
                    .font(.subheadline)
                    .padding(.top, 10)
                    
                    
                    Image("tidi_sun")  // Add your logo to Assets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                }
                .padding()
                .onChange(of: registerViewModel.isRegistered){
                    if registerViewModel.isRegistered{
                        navigateToLogin = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Custom Rounded TextField
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundStyle(.black)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.black)
                    .autocapitalization(.none) // Prevents auto-capitalization
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.black.opacity(0.5), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}


#Preview {
    RegisterView()
}
