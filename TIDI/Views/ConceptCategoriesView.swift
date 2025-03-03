//
//  ConceptCategoriesView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 1/3/2025.
//

import SwiftUI

struct ConceptCategoriesView: View {
    @Environment(\.dismiss) private var dismiss // Modern back navigation method
    @StateObject var viewModel = ConceptViewModel()
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
                    Text("Concept").font(.headline)
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
                            LinearProgressView(progress: progress)
                        }
                        .padding(.top,30)
                        
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.categories, id: \.id) { category in
                                NavigationLink(destination: ConceptAnswersView(businessIdeaId: businessIdeaId, conceptCatId: category.id)) {
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
                                Text("Actionas")
                                    .font(.headline)
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
                viewModel.loadConceptCategories(businessIdeaId: businessIdeaId)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}


//linear progress bar
struct LinearProgressView: View {
    var progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Progress Bar
            ZStack(alignment: .leading) {
                // Background Bar (Full Width)
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 10)
                    .foregroundColor(Color.gray.opacity(0.2))
                
                // Foreground (Progress) Bar
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: max(10, (progress / 100) * geometry.size.width), height: 10) // Ensures it's never 0 width
                        .foregroundColor(progress == 100 ? .green : .black)
                        .animation(.easeInOut, value: progress)
                }
            }
            .frame(height: 10) // Ensure fixed height
            
            // Percentage Text
            HStack {
                Spacer()
                Text("\(Int(progress))% Complete")
                    .font(.system(size: 14, weight: .bold))
            }
        }
        .padding(.horizontal)
    }
}



#Preview {
    ConceptCategoriesView(businessIdeaId: 20, progress: 30)
}
