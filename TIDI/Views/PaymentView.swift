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
    
    @EnvironmentObject
    private var paymentViewModel : PaymentViewModel
    
    
    var body: some View {
        VStack(spacing: 20){
            Text("Products")
            ForEach(paymentViewModel.products) { product in
                Button {
                    // add later
                    _Concurrency.Task {
                        do {
                            try await paymentViewModel.purchase(product)
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
                try await paymentViewModel.loadProducts()
            }catch{
                print(error)
            }
        }
    }
}




#Preview {
    PaymentView()
        .environmentObject(PaymentViewModel())
}
