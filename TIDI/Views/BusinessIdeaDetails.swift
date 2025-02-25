//
//  BusinessIdeaDetails.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 19/2/2025.
//

import SwiftUI

struct BusinessIdeaDetails: View {
    @Environment(\.dismiss) private var dismiss // Modern back navigation method
    @StateObject private var viewModel = BusinessIdeaViewModel()
    let ideaId: Int
    
    var body: some View {
        NavigationStack{
            VStack {
                // Back button
                HStack {
                    Button(action: {
                        dismiss() // Modern back navigation
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                    }
                    .padding(.leading, 10)
                    .padding(.top, 10)
                    Spacer()
                    Text("New Concept").font(.headline)
                        .padding(.trailing, 20)
                    Spacer()
                }
                .padding()
                
                if viewModel.isLoadingSingleBusinessDetails {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let idea = viewModel.businessIdea {
                    // Simple text display of idea details
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            
                            BusinessIdeaCardDeatils(title: "Concept Name", text: idea.idea_name, customFontWeight: .bold, customFontSize: 28)
                            BusinessIdeaCardDeatils(title: "Concept Foundation", text: idea.idea_foundation, customFontWeight: .medium, customFontSize: 20)
                            BusinessIdeaCardDeatils(title: "Problem Statement", text: idea.problem_statement, customFontWeight: .regular, customFontSize: 18)
                            BusinessIdeaCardDeatils(title: "Unique Solution", text: idea.unique_solution, customFontWeight: .regular, customFontSize: 18)
                            BusinessIdeaCardDeatils(title: "Location or country to first target", text: idea.target_location, customFontWeight: .regular, customFontSize: 18)
                            
                            
                            
                            //Text("Status: \(idea.isActive == 1 ? "Active" : "Inactive")")
                            //Text("Progress: \(Int(idea.idea_progress))%")
                            Text("businessIdeaId: \(idea.business_idea_id)")
                        }
                        .padding()
                    }
                } else if let error = viewModel.errorMessageSingleBusinessDetails {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("No data available")
                        .padding()
                }
            }
            .onAppear {
                viewModel.loadSingleBusinessIdeaDetails(business_idea_id: ideaId)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct BusinessIdeaCardDeatils: View {
    var title: String
    var text: String
    var customFontWeight: Font.Weight
    var customFontSize: CGFloat
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                Spacer()
            }
            
            Text(text)
                .font(.system(size: customFontSize))
                .foregroundColor(.black)
                .fontWeight(customFontWeight)
        }
        .padding()
        .background(Color(hex: "#F8F9FB"))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}



#Preview {
    BusinessIdeaDetails(ideaId: 8)
}
