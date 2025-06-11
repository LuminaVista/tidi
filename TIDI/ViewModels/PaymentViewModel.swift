//
//  PaymentViewModel.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 9/6/2025.
//

import Foundation
import StoreKit


@MainActor
class PaymentViewModel: ObservableObject{
    
    
    let productIds = ["tidi.monthly15", "tidi.yearly120"]
    
    @Published
    private(set) var products: [Product] = []
    private var productsLoaded = false
    
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
                await transaction.finish()
            
        case .success(.unverified(_, _)):
            break
        case .pending:
            break
        case .userCancelled:
            break
        @unknown default:
            break
        }
    }
    
    
    
}


