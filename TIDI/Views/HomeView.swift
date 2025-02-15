//
//  HomeView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 10/2/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = BusinessIdeaViewModel()
    @State private var selectedTab = 0  // 0 for Active, 1 for Inactive
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // Beige Background
                Color(hex: "#DDD4C8")
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Logo at the Top
                    VStack {
                        Image("app_logo") // Ensure it's in Assets
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .padding(.top, 50) // Adjust based on safe area
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10) // Space below the logo

                    // White Background Content
                    VStack {
                        // Segmented Control
                        Picker("", selection: $selectedTab) {
                            Text("Active ideas").tag(0)
                            Text("Inactive").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()

                        // Business Ideas List
                        List(filteredIdeas, id: \.id) { idea in
                            VStack(alignment: .leading) {
                                Text(idea.idea_name)
                                    .font(.headline)
                                Text(idea.problem_statement)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)
                        }
                        .listStyle(PlainListStyle())
                        .frame(maxHeight: .infinity)

                        // "New Concept" Button
                        Button(action: {
                            // Action to add a new concept
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("New Concept")
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("BackgroundColor")) // Beige color
                            .cornerRadius(20)
                        }
                        .padding(.bottom, 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(20)
                }
            }
            .onAppear {
                viewModel.loadBusinessIdeas()
            }
        }
    }
    
    // Filter Ideas based on Active/Inactive tab
    private var filteredIdeas: [BusinessIdea] {
        return viewModel.businessIdeas.filter { $0.isActive == selectedTab }
    }
}
#Preview {
    HomeView()
}
