//
//  PaymentViewModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 9/6/2025.
//

import Foundation
import StoreKit

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

    // MARK: - Restore
    func restorePurchases(appVM: AppViewModel?) async {
        isRestoring = true
        restoreError = nil
        defer { isRestoring = false }

        do {
            print("Restore: calling AppStore.sync()")
            try await AppStore.sync()

            // 1) Rebuild from latest transactions (handles local StoreKit quirks)
            let latestSet = await rebuildEntitlementsFromLatest()
            if !latestSet.isEmpty {
                purchasedProductIDs = latestSet
                print("Restore(latest): \(purchasedProductIDs)")
            } else {
                // 2) Fallback to current entitlements stream
                print("Restore: latest empty, trying currentEntitlements…")
                await updatePurchasedProducts()
            }

            let hasAny = !purchasedProductIDs.isEmpty
            print("Restore: hasAny=\(hasAny)")

            // Update AppViewModel state and let it verify through its own method
            if let appVM {
                await MainActor.run {
                    appVM.hasActiveSubscription = hasAny
                }
                // Give the AppViewModel a chance to verify independently
                await appVM.checkSubscriptionStatus()
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


