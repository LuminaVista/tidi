//
//  AppViewModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 10/5/2025.
//

import Foundation

class AppViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var hasLaunchedBefore: Bool

    init() {
        // Check token
        if let token = KeychainHelper.shared.getToken(forKey: "userAuthToken"), !token.isEmpty {
            self.isLoggedIn = true
        } else {
            self.isLoggedIn = false
        }

        // Check first-time launch
        let launched = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        self.hasLaunchedBefore = launched
    }

    func markFirstLaunchComplete() {
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        self.hasLaunchedBefore = true
    }

    func logout() {
        KeychainHelper.shared.deleteToken(forKey: "userAuthToken")
        self.isLoggedIn = false
    }
}

