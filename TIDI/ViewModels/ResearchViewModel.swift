//
//  ResearchViewModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 6/4/2025.
//

import Foundation


class ResearchViewModel: ObservableObject {
    
    
    // Category related
    @Published var categories: [ResearchCategory] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var progress: Double = 0.0
    
    
    func loadResearchCategories(businessIdeaId: Int) {
        isLoading = true
        errorMessage = nil
        
        ResearchService.shared.fetchResearchCategories(businessIdeaId: businessIdeaId) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.categories = response.categories
                    self.progress = response.progress ?? 0.0  // Store progress
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    
    // For AI answers
    @Published var answers: [ResearchAnswer] = []
    @Published var categoryName: String = ""
    @Published var isLoadingAnswers = false
    @Published var answersErrorMessage: String?
    
    // ai generated answer view model
    func loadAIAnswers(businessIdeaId: Int, researchCatId: Int) {
        isLoadingAnswers = true
        answersErrorMessage = nil
        
        ResearchService.shared.fetchAIAnswers(businessIdeaId: businessIdeaId, researchCatId: researchCatId) { result in
            DispatchQueue.main.async {
                self.isLoadingAnswers = false
                switch result {
                case .success(let response):
                    self.categoryName = response.category_name
                    self.answers = response.answers
                case .failure(let error):
                    self.answersErrorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // TASK RELATED
    @Published var tasks: [ResearchTask] = []
    @Published var isLoadingTask = false
    @Published var taskErrorMessage: String?
    
    // TASK RELATED
    func fetchTasks(businessIdeaID: Int) {
        isLoadingTask = true
        taskErrorMessage = nil
        
        ResearchService.fetchTasks(businessIdeaID: businessIdeaID) { result in
            DispatchQueue.main.async {
                self.isLoadingTask = false
                switch result {
                case .success(let fetchedTasks):
                    self.tasks = fetchedTasks.filter { !$0.taskStatus } // Show only tasks that are not done
                case .failure(let error):
                    self.taskErrorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Edit task
    // Mark task as complete
    func completeTask(businessIdeadID: Int, taskID: Int) {
        ResearchService.completeTask(businessIdeadID: businessIdeadID, taskID: taskID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let completedTaskID):
                    if let index = self.tasks.firstIndex(where: { $0.id == completedTaskID }) {
                        self.tasks.remove(at: index) // Safer removal
                    } else {
                        print("Warning: Task ID \(completedTaskID) not found in the local task list.")
                    }
                    
                case .failure(let error):
                    self.taskErrorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // User gen research task
    @Published var userGenTask: [UserGenResearchTask] = []
    @Published var userGenTaskIsLoading = false
    @Published var userGenTaskErrorMessage: String?
    @Published var userGenTaskSuccessMessage: String?
    
    
    // user gen task
    func addTask(businessIdeaID: Int, taskDescription: String) {
        guard !taskDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            // Optional: Prevent adding empty tasks
            return
        }
        
        userGenTaskIsLoading = true
        userGenTaskErrorMessage = nil
        userGenTaskSuccessMessage = nil
        
        ResearchService.shared.addTask(businessIdeaID: businessIdeaID, taskDescription: taskDescription) { [weak self] result in
            DispatchQueue.main.async {
                self?.userGenTaskIsLoading = false
                switch result {
                case .success(let response):
                    self?.userGenTask.append(response.task)
                    self?.userGenTaskSuccessMessage = response.message
                    
                    // Fetch tasks with a small delay to ensure server has processed the new task
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.fetchTasks(businessIdeaID: businessIdeaID)
                    }
                    
                case .failure(let error):
                    self?.userGenTaskErrorMessage = error.localizedDescription
                }
            }
        }
    }
    
    
    // Edit & Approve AI answer
        func editAnswer(_ answer: ResearchAnswer, newContent: String) {
            isLoadingAnswers = true; answersErrorMessage = nil
            ResearchService.shared.editAndApproveAnswer(researchAnswerId: answer.research_answer_id, newContent: newContent) { result in
                DispatchQueue.main.async {
                    self.isLoadingAnswers = false
                    switch result {
                    case .success(let resp):
                        if let idx = self.answers.firstIndex(where: { $0.research_answer_id == resp.research_answer_id }) {
                            self.answers[idx].answer = resp.approved_answer
                        }
                    case .failure(let e): self.answersErrorMessage = e.localizedDescription
                    }
                }
            }
        }

    
}



