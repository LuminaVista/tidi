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
                            Text("Active ideas").tag(1)
                            Text("Inactive").tag(0)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        
                        // Business Ideas List
                        // Business Ideas List
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(filteredIdeas, id: \.id) { idea in
                                    BusinessIdeaCard(idea: idea)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxHeight: .infinity)
                        
                        // "New Concept" Button
                        Button(action: {
                            // Action to add a new concept
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.black)
                                Text("New Concept")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#DDD4C8")) // Beige color
                            .cornerRadius(20)
                        }
                        .padding(20)
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

// MARK: - Business Idea Card Component
struct BusinessIdeaCard: View {
    var idea: BusinessIdea
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(idea.idea_name)
                    .font(.title3)
                    .bold()
                
                Spacer()
                // todo: Action Button
            }
            
            Text(idea.problem_statement)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                // todo: User Avatars
                // Progress Ring
                Spacer()
                CircularProgressView(progress: idea.idea_progress)
                    .frame(width: 80, height: 80)
                Spacer()
            }
            .padding(20)
        }
        .padding()
        .background(idea.isActive == 1 ? Color(hex: "#F5F4F2") : Color(hex: "#DDEAE5"))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}


// MARK: - Circular Progress View
struct CircularProgressView: View {
    var progress: Double
    
    var body: some View {
        ZStack {
            // Background Half Circle
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                .rotationEffect(.degrees(180))
            
            // Progress Half Circle
            Circle()
                .trim(from: 0, to: progress / 200) // Divide by 200 instead of 100 since we're using half circle
                .stroke(Color.black, style: StrokeStyle(
                    lineWidth: 12,
                    lineCap: .round
                ))
                .rotationEffect(.degrees(180))
            
            // Percentage Text
            VStack {
                Text("\(Int(progress))%")
                    .font(.system(size: 32, weight: .bold))
                Text("Done")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            .offset(y: -10) // Move text slightly up to center it in the half circle
        }
        .frame(height: 120) // Adjust the frame to better fit the half circle
        .padding(.top, 20) // Add some padding at the top
    }
}

#Preview {
    HomeView()
}
