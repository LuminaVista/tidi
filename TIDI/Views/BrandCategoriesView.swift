//
//  BrandCategoriesView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 17/5/2025.
//

import SwiftUI

struct BrandCategoriesView: View {
    @Environment(\.dismiss) private var dismiss // Modern back navigation method
    @StateObject var viewModel = BrandViewModel()
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
                    Text("Environmental Consideration").font(.headline)
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
                                NavigationLink(destination: BrandAnswersView(businessIdeaId: businessIdeaId, brandCatId: category.id)) {
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
                                NavigationLink(destination: BrandTaskView(businessIdeaID: businessIdeaId)){
                                    Text("Actions")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            HStack {
                                NavigationLink(destination: BrandLogo(businessIdeaId: businessIdeaId)){
                                    Text("Generate AI Logo")
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
                viewModel.loadBrandCategories(businessIdeaId: businessIdeaId)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    BrandCategoriesView(businessIdeaId: 97, progress: 0)
}
