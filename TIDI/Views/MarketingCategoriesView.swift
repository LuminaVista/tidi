//
//  MarketingCategoriesView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 7/4/2025.
//

import SwiftUI

struct MarketingCategoriesView: View {
    
    @Environment(\.dismiss) private var dismiss // Modern back navigation method
    @StateObject var viewModel = MarketingViewModel()
    let businessIdeaId: Int
    let progress: Double
    
    var body: some View {
        NavigationStack{
            VStack{
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
                    Text("Marketing").font(.headline)
                        .padding(.trailing, 20)
                    Spacer()
                }
                .padding(.top, 30)
                
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    ScrollView {
                        
                        // show the progress bar here:
                        HStack{
                            LinearProgressView(progress: viewModel.progress)
                        }
                        .padding(.top,30)
                        
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.categories, id: \.id) { category in
                                NavigationLink(destination: MarketingAnswersView(businessIdeaId: businessIdeaId, marketingCatId: category.id)) {
                                    HStack {
                                        Text(category.name)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                                }
                                
                            }
                            HStack {
                                NavigationLink(destination: MarketingTaskView(businessIdeaID: businessIdeaId)){
                                    Text("Actions")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .padding()
                        
                    }
                }
            }
            .onAppear {
                viewModel.loadMarketingCategories(businessIdeaId: businessIdeaId)
            }
            .navigationBarBackButtonHidden(true)
        }
    }

}

#Preview {
    MarketingCategoriesView(businessIdeaId: 87, progress: 0)
}
