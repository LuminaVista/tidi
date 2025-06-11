//
//  PaymentView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 11/6/2025.
//

import SwiftUI
import StoreKit
import _Concurrency

struct PaymentView: View {
    
    let productIds = ["tidi.monthly15", "tidi.yearly120"]
    
    @State
    private var products: [Product] = []
    
    var body: some View {
        VStack(spacing: 20){
            Text("Products")
            ForEach(self.products) { product in
                Button {
                    // add later
                    _Concurrency.Task {
                        do {
                            try await self.purchase(product)
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("\(product.displayPrice) - \(product.displayName)")
                }
            }
        }.task{
            do{
                try await self.loadProducts()
            }catch{
                print(error)
            }
        }
    }
    
    private func loadProducts() async throws {
        self.products = try await Product.products(for: productIds)
    }
    
    private func purchase(_ product: Product) async throws {
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




#Preview {
    PaymentView()
}
