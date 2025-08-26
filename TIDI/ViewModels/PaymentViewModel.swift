//
//  PaymentViewModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 9/6/2025.
//

import Foundation
import StoreKit
import _Concurrency

@MainActor
class PaymentViewModel: ObservableObject {

    
    let productIds = ["tidi.monthly15v2", "tidi.yearly120v2"]

    @Published private(set) var products: [Product] = []
    private var productsLoaded = false

    @Published private(set) var purchasedProductIDs = Set<String>()
    @Published var isRestoring = false
    @Published var restoreError: String?

    var hasUnlockedPro: Bool { !purchasedProductIDs.isEmpty }

    // MARK: - Products
    func loadProducts() async throws {
        guard !productsLoaded else { return }
        products = try await Product.products(for: productIds)
        productsLoaded = true
        print("Loaded products: \(products.map { $0.id })")
    }

    // MARK: - Purchase
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        switch result {
        case let .success(.verified(tx)):
            await tx.finish()
            await updatePurchasedProducts()
        case .success(.unverified(_, _)):
            break
        case .pending, .userCancelled:
            break
        @unknown default:
            break
        }
    }

    // MARK: - Entitlements (current)
    func updatePurchasedProducts() async {
        
        var newSet = Set<String>()
        print("=== updatePurchasedProducts ===")
        for await result in Transaction.currentEntitlements {
            print("Entitlement result: \(result)")
            guard case .verified(let tx) = result else {
                print("Unverified transaction")
                continue
            }
            print("Transaction: \(tx.productID), revoked: \(tx.revocationDate != nil), expires: \(String(describing: tx.expirationDate))")
            if tx.revocationDate == nil,
               (tx.expirationDate ?? .distantFuture) > Date() {
                newSet.insert(tx.productID)
            }
        }
        print("Final purchasedProductIDs: \(purchasedProductIDs)")
        purchasedProductIDs = newSet
        print("Entitlements after refresh: \(purchasedProductIDs)")
    }
    

    // MARK: - Entitlements (latest per product) — more reliable in Simulator after sync
    private func rebuildEntitlementsFromLatest() async -> Set<String> {
        var ids = Set<String>()
        print("=== rebuildEntitlementsFromLatest ===")
        for id in productIds {
            print("Checking latest for product: \(id)")
            if let res = await Transaction.latest(for: id) {
                print("Latest transaction result: \(res)")
                switch res {
                case .verified(let tx):
                    print("Latest transaction: \(tx.productID), revoked: \(tx.revocationDate != nil), expires: \(String(describing: tx.expirationDate))")
                    if tx.revocationDate == nil,
                       (tx.expirationDate ?? .distantFuture) > Date() {
                        ids.insert(tx.productID)
                        print("Added \(tx.productID) to entitlements")
                    } else {
                        print("Transaction \(tx.productID) is revoked or expired")
                    }
                case .unverified:
                    print("Unverified latest transaction for \(id)")
                    break
                }
            } else {
                print("No latest transaction for \(id)")
            }
        }
        print("Final latest IDs: \(ids)")
        return ids
    }
    
    
    // Modified timeout wrapper that can throw
    private func getAllTransactionsWithTimeout() async throws -> Set<String> {
        return try await withThrowingTaskGroup(of: Set<String>.self) { group in
            group.addTask {
                var found = Set<String>()
                for await result in Transaction.all {
                    guard case .verified(let transaction) = result else { continue }
                    
                    if self.productIds.contains(transaction.productID),
                       transaction.revocationDate == nil,
                       (transaction.expirationDate ?? .distantFuture) > Date() {
                        await transaction.finish()
                        found.insert(transaction.productID)
                    }
                }
                return found
            }
            
            group.addTask {
                try await _Concurrency.Task.sleep(nanoseconds: 10_000_000_000) // 10 second timeout
                throw CancellationError() // Timeout error
            }
            
            // Return first result (either transactions found or timeout)
            for try await result in group {
                group.cancelAll()
                return result
            }
            return Set<String>()
        }
    }

    // MARK: - Restore
    func restorePurchases(appVM: AppViewModel?) async {
        isRestoring = true
        restoreError = nil
        defer { isRestoring = false }

        do {
            print("Restore: calling AppStore.sync()")
            try await AppStore.sync()
            
            // Give time for sync to complete
            try await _Concurrency.Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            var foundTransactions = Set<String>()
            
            // METHOD 1: Transaction.all with timeout protection
            print("Restore: Checking Transaction.all for complete purchase history")
            do {
                foundTransactions = try await getAllTransactionsWithTimeout()
                print("Found valid transactions from history: \(foundTransactions)")
            } catch {
                print("Transaction.all failed: \(error)")
            }
            // added something
            // METHOD 2: If Transaction.all didn't find anything, try latest per product
            if foundTransactions.isEmpty {
                print("No transactions found in history, checking latest per product")
                let latestSet = await rebuildEntitlementsFromLatest()
                foundTransactions = latestSet
            }
            
            // METHOD 3: Final fallback to current entitlements
            if foundTransactions.isEmpty {
                await updatePurchasedProducts()
                foundTransactions = purchasedProductIDs
            }
            
            // Update our state
            purchasedProductIDs = foundTransactions
            let hasAny = !foundTransactions.isEmpty
            print("Restore complete: hasAny=\(hasAny), products=\(foundTransactions)")

            // Update AppViewModel - simplified approach
            if let appVM {
                if hasAny {
                    // We found active subscriptions
                    await MainActor.run {
                        appVM.hasActiveSubscription = true
                    }
                } else {
                    // No subscriptions found, let AppViewModel double-check
                    await appVM.checkSubscriptionStatus()
                }
            }
            
            // Set appropriate error message
            if !hasAny {
                restoreError = "No active subscriptions found to restore. If you believe this is an error, please contact support."
            } else {
                restoreError = nil
            }
            
        } catch {
            restoreError = error.localizedDescription
            print("Restore error: \(error)")
        }
    }
    
    
    // Add this method to PaymentViewModel
    func syncWithAppViewModel(_ appVM: AppViewModel) async {
        
        await updatePurchasedProducts()
        let hasAny = !purchasedProductIDs.isEmpty
        await MainActor.run {
            appVM.hasActiveSubscription = hasAny
        }
    }
    
}


