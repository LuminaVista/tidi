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
    @Published var isCheckingSubscription: Bool = true // Add this
    
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
    
    // This only checks current entitlements (no restore)
    func checkCurrentEntitlements() async {
        print("=== AppViewModel.checkCurrentEntitlements ===")
        for await result in Transaction.currentEntitlements {
            print("AppViewModel entitlement: \(result)")
            if case .verified(let transaction) = result,
               transaction.revocationDate == nil,
               (transaction.expirationDate ?? .distantFuture) > Date() {
                print("AppViewModel found valid subscription: \(transaction.productID)")
                await MainActor.run {
                    self.hasActiveSubscription = true
                    self.isCheckingSubscription = false
                }
                return
            }
        }
        print("AppViewModel: No valid subscriptions found")
        await MainActor.run {
            self.hasActiveSubscription = false
            self.isCheckingSubscription = false
        }
    }
    
    // This is for manual restore (called from button)
    func checkSubscriptionStatus() async {
        print("=== AppViewModel.checkSubscriptionStatus (Manual Restore) ===")
        // This can be more comprehensive and include restore logic
        for await result in Transaction.currentEntitlements {
            print("AppViewModel entitlement: \(result)")
            if case .verified(let transaction) = result,
               transaction.revocationDate == nil,
               (transaction.expirationDate ?? .distantFuture) > Date() {
                print("AppViewModel found valid subscription: \(transaction.productID)")
                await MainActor.run {
                    self.hasActiveSubscription = true
                }
                return
            }
        }
        print("AppViewModel: No valid subscriptions found")
        await MainActor.run {
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
    
    func deleteAndLogout() {
        KeychainHelper.shared.deleteToken(forKey: "userAuthToken")
        self.isLoggedIn = false
    }
    
    func logout() {
        KeychainHelper.shared.deleteToken(forKey: "userAuthToken")
        self.isLoggedIn = false
    }
}

