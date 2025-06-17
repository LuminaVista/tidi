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
    
    
    @EnvironmentObject private var paymentViewModel : PaymentViewModel
    @EnvironmentObject private var appViewModel:   AppViewModel
    
    var onComplete: (() -> Void)? = nil
    
    var body: some View {
        
        ZStack {
            Color(hex: "#DDD4C8")
                .ignoresSafeArea()
            VStack(spacing: 20){
                Spacer()
                Image("app_logo") // Replace "logo" with your image name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                
                ForEach(paymentViewModel.products) { product in
                    let isTrial = product.subscription?.introductoryOffer?.paymentMode == .freeTrial
                    
                    Button {
                        // add later
                        _Concurrency.Task {
                            do {
                                try await paymentViewModel.purchase(product)
                                await MainActor.run {
                                    appViewModel.hasActiveSubscription = true
                                }
                                onComplete?()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        VStack{
//                            Text("\(product.displayPrice)")
//                                .fontWeight(.bold)
//                                .padding(.bottom,5)
//                            Text("\(product.displayName)")
                            Text(isTrial ? "Start Free Trial" : product.displayPrice)
                                .fontWeight(.bold)
                                .foregroundColor(isTrial ? .black : .white)
                                .padding(5)
                            
                            if isTrial {
                                Text("7-day free trial, then \(product.displayPrice)/month")
                                    .fontWeight(.regular)
                            }
                            
                        }
                        .padding(15)
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(20)
                }
                .padding(.horizontal, 40)
                
                Text("Choose the product that fits for you")
                    .fontWeight(.thin)
                
                Spacer()
            }
            .task{
                do{
                    try await paymentViewModel.loadProducts()
                }catch{
                    print(error)
                }
            }
        }
        
    }
}




#Preview {
    PaymentView()
        .environmentObject(PaymentViewModel())
}
