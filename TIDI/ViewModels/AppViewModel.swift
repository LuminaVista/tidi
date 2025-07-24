//
//  AppViewModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 10/5/2025.
//

import Foundation
import StoreKit

class AppViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var hasLaunchedBefore: Bool
    @Published var hasActiveSubscription: Bool = false

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
    
    func checkSubscriptionStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.revocationDate == nil,
               transaction.expirationDate ?? .distantPast > Date() {
                DispatchQueue.main.async {
                    self.hasActiveSubscription = true
                }
                return
            }
        }
        DispatchQueue.main.async {
            self.hasActiveSubscription = false
        }
    }
    
    func isSubscriptionExpired() async -> Bool {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               let expiry = transaction.expirationDate {
                return expiry < Date()
            }
        }
        return true
    }
    
    
    func logout() {
        KeychainHelper.shared.deleteToken(forKey: "userAuthToken")
        self.isLoggedIn = false
    }
}

