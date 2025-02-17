//
//  BusinessIdeaCreateView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 17/2/2025.
//

import SwiftUI

struct BusinessIdeaCreateView: View {
    @Environment(\.dismiss) private var dismiss // Modern back navigation method
    @StateObject private var viewModel = BusinessIdeaViewModel()
    @State private var navigateFromBICreateToHome = false  // Track navigation state
    
    var body: some View {
        NavigationView {
            
            ZStack(alignment: .top){
                // Beige Background
                Color(hex: "#DDD4C8")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Logo at the Top
                    VStack {
                        HStack{
                            Button(action: {
                                dismiss() // Modern back navigation
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                            }
                            .padding(.leading)
                            .padding(.top, 30)
                            Spacer()
                            Image("app_logo") // Ensure it's in Assets
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                                .padding(.top, 20) // Adjust based on safe area
                                .padding(.bottom, 10) // Adjust based on safe area
                            Spacer()
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10) // Space below the logo
                    // White Background Content
                    
                    NavigationView{
                        ScrollView{
                            VStack(spacing: 20){
                                CustomeTextFieldBusinessIdeaCreate(title: "Concept name", text: $viewModel.ideaName)
                                CustomeTextFieldBusinessIdeaCreate(title: "Concept Foundation", text: $viewModel.ideaFoundation)
                                CustomeTextFieldBusinessIdeaCreate(title: "Problem Statement", text: $viewModel.problemStatement)
                                CustomeTextFieldBusinessIdeaCreate(title: "Unique Solution", text: $viewModel.uniqueSolution)
                                CustomeTextFieldBusinessIdeaCreate(title: "Location or Country to first target", text: $viewModel.targetLocation)
                                
                            }
                            
                            // Submit Button
                            Button(action: {
                                viewModel.submitIdea()
                            }) {
                                Text("Submit Idea")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(Color(hex: "#DDD4C8"))
                                    .foregroundColor(isFormValid ? .black : .gray)
                                    .cornerRadius(10)
                            }
                            .disabled(!isFormValid)
                            
                        }
                        .padding()
                        
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(edges: .bottom)
                    
                }
                
            }
            .navigationDestination(isPresented: $navigateFromBICreateToHome) {
                HomeView()  // Navigate to HomeView when logged in
            }
            .onChange(of: viewModel.isLoadingBICreate){
                if viewModel.isLoadingBICreate{
                    navigateFromBICreateToHome = true
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // Computed Property to Check Form Validity
    private var isFormValid: Bool {
        !viewModel.ideaName.isEmpty &&
        !viewModel.ideaFoundation.isEmpty &&
        !viewModel.problemStatement.isEmpty &&
        !viewModel.uniqueSolution.isEmpty &&
        !viewModel.targetLocation.isEmpty
    }
}

struct CustomeTextFieldBusinessIdeaCreate: View {
    var title: String
    @Binding var text: String
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.horizontal, 10)
                .padding(.top, 5)
                .padding(.bottom, 5)
            
            if isMultiline {
                TextEditor(text: $text)
                    .frame(height: 80)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
            } else {
                TextField("", text: $text)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(hex: "#E6DED3")) // Light beige background
        .cornerRadius(15)
        //        .overlay( // Adding Black Stroke Border
        //            RoundedRectangle(cornerRadius: 15)
        //                .stroke(Color.gray, lineWidth: 2)
        //        )
    }
}

#Preview {
    BusinessIdeaCreateView()
}
