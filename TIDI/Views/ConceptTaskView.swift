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

struct TaskCard: View {
    let title: String
    let iconName: String // System image icon name
    let tasks: [String]
    let markAsDone: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title Row with Icon
            HStack {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(.black.opacity(0.8))
                    .padding(8)
                    .background(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                
                Text(title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.bottom, 5)
            
            Divider()
            
            // Task List
            VStack(alignment: .leading, spacing: 6) {
                ForEach(tasks, id: \.self) { task in
                    HStack(alignment: .top, spacing: 5) {
                        Text("•") // Bullet point
                            .font(.title3)
                        Text(task)
                            .font(.body)
                            .foregroundColor(.black.opacity(0.8))
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .padding(.bottom, 10)
            
            // Add Button
            Button(action: markAsDone) {
                HStack {
                    Text("Mark as Done")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        .shadow(color: Color.black.opacity(0.1), radius: 5)
        .padding(.horizontal)
    }
}

func generateTitle(index: Int) -> String {
    let titles = ["A’s", "B’s", "C’s"]
    return index < titles.count ? titles[index] : "User Generated Task"
}

func generateIcon(index: Int) -> String {
    let icons = ["clock", "brain.head.profile", "lightbulb"]
    return index < icons.count ? icons[index] : "plus.square" // Generic icon for user-generated tasks
}

#Preview {
    ConceptTaskView(businessIdeaID: 13)
}
