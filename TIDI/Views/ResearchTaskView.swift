//
//  ResearchTaskView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 6/4/2025.
//

import SwiftUI

struct ResearchTaskView: View {
    
    @Environment(\.dismiss) private var dismiss // Modern back navigation method
    @StateObject private var viewModel = ResearchViewModel()
    
    @State private var isAddingTask = false // Tracks whether user is adding a new task
    @State private var newTaskDescription = "" // Stores new task input
    @State private var refreshTasks = false // Track if tasks are updated
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
                    Text("Actions")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.trailing, 20)
                    Spacer()
                }
                .padding(.top, 20)
                
                HStack{
                    Text("Track the things you need to bring your idea to life")
                        .font(.system(size: 14))
                        .opacity(0.7)
                }
                .padding(.top,5)
                .padding(.bottom, 5)
                
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
                            ForEach(Array(viewModel.tasks.enumerated()), id: \.element.id) { index, task in
                                TaskCard(
                                    title: generateTitle(index: index), // Assign A’s, B’s, or C’s
                                    iconName: generateIcon(index: index), // Assign different icons
                                    tasks: [task.taskDescription] // Assuming each task has a single description
                                ) {
                                    viewModel.completeTask(businessIdeadID: businessIdeaID, taskID: task.id)
                                }
                            }
                        }
                    }
                    // Add a "Create Task" button upon which user can click and a textfield along with "Add Task" button will arrive
                    // The "Create Task" button will disappear. and upon the click on "Add Task" the addTask function will be called.
                    if isAddingTask {
                        VStack {
                            TextField("Enter new task", text: $newTaskDescription)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            HStack {
                                Button(action: {
                                    isAddingTask = false // Hide input field
                                    newTaskDescription = "" // Clear input
                                }) {
                                    Text("Cancel")
                                        .foregroundColor(.red)
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    viewModel.addTask(businessIdeaID: businessIdeaID, taskDescription: newTaskDescription)
                                    viewModel.fetchTasks(businessIdeaID: businessIdeaID) // Add this line
                                    isAddingTask = false
                                    newTaskDescription = "" // Reset input
                                }) {
                                    Text("Add Task")
                                        .foregroundColor(.black)
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color(hex: "#DDD4C8"))
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                    } else {
                        Button(action: {
                            isAddingTask = true // Show input field
                        }) {
                            Text("Create Task")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#DDD4C8"))
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                viewModel.fetchTasks(businessIdeaID: businessIdeaID)
            }
            // Updated `onChange` implementation
            .onChange(of: refreshTasks) { oldValue, newValue in
                // This will trigger a refresh of the task list
                viewModel.fetchTasks(businessIdeaID: businessIdeaID)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ResearchTaskView(businessIdeaID: 84)
}
