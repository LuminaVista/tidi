//
//  ResetPasswordView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 31/3/2025.
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var viewModel = ResetPasswordViewModel()
        @Environment(\.dismiss) var dismiss

        var body: some View {
            VStack(spacing: 20) {
                
                HStack{
                    Button(action: {
                        dismiss() // Modern back navigation
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                    }
                    .padding(.leading, 15)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    Text("Forgot Password")
                        .font(.title3)
                        .fontWeight(.bold)
                    Spacer()
                }
                
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Process of Reset Password")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.bottom, 5)

                    Group {
                        HStack(alignment: .top) {
                            Text("•")
                            Text("Please provide the email address")
                        }
                        HStack(alignment: .top) {
                            Text("•")
                            Text("After verification the reset link will be sent to the email.")
                        }
                        HStack(alignment: .top) {
                            Text("Note: The password reset link might take few minutes to appear in your email.")
                                .foregroundColor(.red)
                        }
                    }
                    .font(.body)
                    .padding(.leading, 5)
                }
                .padding(.top, 50)
                
                VStack{
                    TextField("Enter your email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    }

                    if let success = viewModel.successMessage {
                        Text(success)
                            .foregroundColor(.green)
                    }

                    if viewModel.isLoading {
                        ProgressView()
                    }

                    Button("Send Reset Link") {
                        viewModel.sendResetRequest()
                    }
                    .disabled(viewModel.isLoading)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#C8DCD8"))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.top, 30)

                
                
                Spacer()
            }
            .padding()
            .onChange(of: viewModel.navigateToLogin) {
                if viewModel.navigateToLogin {
                    dismiss()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
}

#Preview {
    ResetPasswordView()
}
