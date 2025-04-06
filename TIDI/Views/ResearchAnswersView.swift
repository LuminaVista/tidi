//
//  ResearchAnswersView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 6/4/2025.
//

import SwiftUI

struct ResearchAnswersView: View {
    
    @Environment(\.dismiss) private var dismiss // Modern back navigation method
    @StateObject private var viewModel = ResearchViewModel()
    let businessIdeaId: Int
    let researchCatId: Int
    
    
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoadingAnswers {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    } else if let errorMessage = viewModel.answersErrorMessage {
                        ErrorView(message: errorMessage, retryAction: {
                            viewModel.loadAIAnswers(businessIdeaId: businessIdeaId, researchCatId: researchCatId)
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
                            AnswerCardViewResearch(answer: answer)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.loadAIAnswers(businessIdeaId: businessIdeaId, researchCatId: researchCatId)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct AnswerCardViewResearch: View {
    let answer: ResearchAnswer
    
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
    ResearchAnswersView(businessIdeaId: 84, researchCatId: 2)
}
