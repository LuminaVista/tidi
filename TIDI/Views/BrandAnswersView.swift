//
//  BrandAnswersView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 17/5/2025.
//

import SwiftUI

struct BrandAnswersView: View {
    @Environment(\.dismiss) private var dismiss // Modern back navigation method
    @StateObject private var viewModel = BrandViewModel()
    let businessIdeaId: Int
    let brandCatId: Int
    
    
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
                            viewModel.loadAIAnswers(businessIdeaId: businessIdeaId, brandCatId: brandCatId)
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
                            AnswerCardViewBrand(answer: answer)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.loadAIAnswers(businessIdeaId: businessIdeaId, brandCatId: brandCatId)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct AnswerCardViewBrand: View {
    let answer: BrandAnswer
    
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

struct BouncingDots: View {
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { i in
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(y: animate ? -5 : 5)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(i) * 0.2),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }
}

#Preview {
    BrandAnswersView(businessIdeaId: 97, brandCatId: 2)
}
