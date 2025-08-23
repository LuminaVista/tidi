import Foundation

class SettingsViewModel: ObservableObject {
    @Published var retypedEmail = ""
    @Published var isDeleting = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    var appViewModel: AppViewModel?

    func deleteAccount() {
        guard let appViewModel = appViewModel else {
            self.errorMessage = "AppViewModel not available."
            return
        }

        isDeleting = true
        errorMessage = nil
        successMessage = nil

        AuthenticationService.shared.deleteAccount(email: retypedEmail) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isDeleting = false

                switch result {
                case .success(let response):
                    print("Server response: \(response.status) \(response.message ?? response.error ?? "")")
                    if response.status == 200 {
                        self.successMessage = response.message ?? "Account deleted."
                        appViewModel.deleteAndLogout()   // or appViewModel.logout()
                    } else {
                        self.errorMessage = response.error ?? "Deletion failed (\(response.status))."
                    }

                case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
