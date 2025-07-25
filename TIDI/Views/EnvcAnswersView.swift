//
//  EnvcAnswersView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 9/4/2025.
//

import SwiftUI

struct EnvcAnswersView: View {
    
    @Environment(\.dismiss) private var dismiss // Modern back navigation method
    @StateObject private var viewModel = EnvcViewModel()
    let businessIdeaId: Int
    let envcCatId: Int
    
    
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoadingAnswers {
                        VStack {
                            Spacer()
                            BouncingDots()
                            Text("Analysing & Fetching Response...")
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .padding(20)
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                    } else if let errorMessage = viewModel.answersErrorMessage {
                        ErrorView(message: errorMessage, retryAction: {
                            viewModel.loadAIAnswers(businessIdeaId: businessIdeaId, envcCatId: envcCatId)
                        })
                    } else {
                        HStack {
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
                            Text(viewModel.categoryName)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.trailing, 20)
                            Spacer()
                        }
                        .padding(.top, 30)
                        
                        ForEach(viewModel.answers) { answer in
                            AnswerCardViewEnvc(answer: answer)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.loadAIAnswers(businessIdeaId: businessIdeaId, envcCatId: envcCatId)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct AnswerCardViewEnvc: View {
    let answer: EnvcAnswer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(answer.question)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.bottom, 4)
            
            ForEach(answer.bulletPoints, id: \.self) { point in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .foregroundColor(.black)
                        .padding(.top, 6)
                    
                    Text(point)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .background(Color(hex: "#F8F9FB"))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    EnvcAnswersView(businessIdeaId: 91, envcCatId: 2)
}
