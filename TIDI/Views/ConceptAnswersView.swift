//
//  ConceptAnswersView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 3/3/2025.
//

import SwiftUI

struct ConceptAnswersView: View {
    @Environment(\.dismiss) private var dismiss  // Modern back navigation method
    @StateObject private var viewModel = ConceptViewModel()
    let businessIdeaId: Int
    let conceptCatId: Int
    
    
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
                        ErrorView(
                            message: errorMessage,
                            retryAction: {
                                viewModel.loadAIAnswers(
                                    businessIdeaId: businessIdeaId,
                                    conceptCatId: conceptCatId)
                            })
                    } else {
                        HStack {
                            Button(action: {
                                dismiss()  // Modern back navigation
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
                            AnswerCardView(answer: answer, viewModel: viewModel)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.loadAIAnswers(
                businessIdeaId: businessIdeaId, conceptCatId: conceptCatId)
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct AnswerCardView: View {
    let answer: ConceptAnswer
    @ObservedObject var viewModel: ConceptViewModel
    @State private var isEditing = false
    @State private var editedContent = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(answer.question)
                .font(.headline)
                .foregroundColor(.primary)
            
            if isEditing {
                TextEditor(text: $editedContent)
                    .frame(minHeight: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5)))
            } else {
                ForEach(answer.bulletPoints, id: \.self) { point in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
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
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                    .frame(maxWidth: .infinity, maxHeight: 25)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(hex: "#2C2A2A"))
                    .cornerRadius(8)
                }
                
                Button {
                    let toSubmit = isEditing ? editedContent : answer.answer
                    viewModel.editAnswer(answer, newContent: toSubmit)
                    isEditing = false
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Approve")
                    }
                    .frame(maxWidth: .infinity, maxHeight: 25)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(hex: "#E6DED3"))
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

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.orange)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button(action: retryAction) {
                Text("Try Again")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10)
    }
}

#Preview {
    ConceptAnswersView(businessIdeaId: 104, conceptCatId: 1)
}
