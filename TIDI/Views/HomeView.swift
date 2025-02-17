//
//  HomeView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 10/2/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = BusinessIdeaViewModel()
    @State private var selectedTab = 1  // 1 for Active, 0 for Inactive
    
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
                            .padding(.top, 20) // Adjust based on safe area
                            .padding(.bottom, 10) // Adjust based on safe area
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
                        NavigationLink(destination: BusinessIdeaCreateView()) {
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
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(20)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .onAppear {
                viewModel.loadBusinessIdeas()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    // Filter Ideas based on Active/Inactive tab
    private var filteredIdeas: [BusinessIdea] {
        return viewModel.businessIdeas.filter { ($0.isActive == 1) == (selectedTab == 1) }
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
        .background(idea.isActive == 1 ? Color(hex: "#EEEBE8") : Color(hex: "#DDEAE5"))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}


struct CircularProgressView: View {
    var progress: Double
    
    var body: some View {
        ZStack {
            // Background Arc
            Circle()
                .trim(from: 0.1, to: 0.9) // This creates the arc
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                .rotationEffect(.degrees(90))  // Rotated to start from the right
            
            // Progress Arc
            Circle()
                .trim(from: 0.1, to: 0.1 + (0.8 * progress / 100)) // Scale progress to the arc length
                .stroke(Color.black, style: StrokeStyle(
                    lineWidth: 8,
                    lineCap: .round
                ))
                .rotationEffect(.degrees(90))  // Rotated to start from the right
            
            // Percentage Text
            VStack(spacing: 2) {
                Text("\(Int(progress))%")
                    .font(.system(size: 22, weight: .bold))
                Text("Done")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 100, height: 100)
    }
}

#Preview {
    HomeView()
}
