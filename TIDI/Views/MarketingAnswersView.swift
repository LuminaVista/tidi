//
//  MarketingAnswersView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 7/4/2025.
//

import SwiftUI

struct MarketingAnswersView: View {
    
    @Environment(\.dismiss) private var dismiss // Modern back navigation method
    @StateObject private var viewModel = MarketingViewModel()
    let businessIdeaId: Int
    let marketingCatId: Int
    
    
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
                            viewModel.loadAIAnswers(businessIdeaId: businessIdeaId, marketingCatId: marketingCatId)
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
                            AnswerCardViewMarketing(answer: answer, viewModel: viewModel)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.loadAIAnswers(businessIdeaId: businessIdeaId, marketingCatId: marketingCatId)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct AnswerCardViewMarketing: View {
    let answer: MarketingAnswer
    @ObservedObject var viewModel: MarketingViewModel
    @State private var isEditing = false
    @State private var editedContent = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(answer.question)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.bottom, 4)

            if isEditing {
                TextEditor(text: $editedContent)
                    .frame(minHeight: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5))
                    )
            } else {
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

            HStack(spacing: 16) {
                Button {
                    editedContent = answer.answer
                    isEditing.toggle()
                } label: {
                    Label("Edit", systemImage: "pencil")
                        .frame(maxWidth: .infinity, maxHeight: 25)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(hex: "#2C2A2A"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button {
                    let content = isEditing ? editedContent : answer.answer
                    viewModel.editAnswer(answer, newContent: content)
                    isEditing = false
                } label: {
                    Label("Approve", systemImage: "checkmark")
                        .frame(maxWidth: .infinity, maxHeight: 25)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(hex: "#E6DED3"))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
        }
        .padding(20)
        .background(Color(hex: "#F8F9FB"))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    MarketingAnswersView(businessIdeaId: 87, marketingCatId: 1)
}
