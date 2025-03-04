//
//  ConceptTaskView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 4/3/2025.
//

import SwiftUI

struct ConceptTaskView: View {
    @Environment(\.dismiss) private var dismiss // Modern back navigation method
    @StateObject private var viewModel = ConceptViewModel()
    let businessIdeaID: Int // Passed from parent view
    
    var body: some View {
        NavigationStack {
            VStack {
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
                    Text("AI Generated Task List").font(.headline)
                        .padding(.trailing, 20)
                    Spacer()
                }
                .padding(.top, 30)
                
                if viewModel.isLoadingTask {
                    ProgressView("Fetching tasks...") // Loading Indicator
                        .padding()
                } else if let errorMessage = viewModel.taskErrorMessage {
                    VStack {
                        Text("⚠️ Error loading tasks")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Retry") {
                            viewModel.fetchTasks(businessIdeaID: businessIdeaID) // Retry Fetching
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                } else if viewModel.tasks.isEmpty {
                    Text("No pending tasks!")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.tasks, id: \.id) { task in
                                TaskCard(task: task) {
                                    viewModel.completeTask(businessIdeadID: businessIdeaID, taskID: task.id)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                viewModel.fetchTasks(businessIdeaID: businessIdeaID)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
}

struct TaskCard: View {
    let task: Task
    let markAsDone: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(task.taskDescription)
                .font(.body)
                .foregroundColor(.primary)
            
            Button(action: markAsDone) {
                Text("Mark as Done")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.systemBackground)))
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

#Preview {
    ConceptTaskView(businessIdeaID: 22)
}
