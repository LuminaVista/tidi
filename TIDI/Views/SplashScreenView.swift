//
//  SplashScreenView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 9/2/2025.
//

import SwiftUI
import _Concurrency

struct SplashScreenView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var paymentViewModel: PaymentViewModel
//    @State private var navigate = false
//    @State private var navigateToPayment = false
//    @State private var navigateToRegister = false
    
    var body: some View {
        ZStack {
            Color(hex: "#DDD4C8")
                .ignoresSafeArea()
            Image("app_logo") // Replace "logo" with your image name
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
        }
        
//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                //navigate = true
//                _Concurrency.Task {
//                    await appViewModel.checkSubscriptionStatus()
//                    if !appViewModel.hasActiveSubscription {
//                        navigateToPayment = true
//                    } else if !appViewModel.hasLaunchedBefore {
//                        navigateToRegister = true
//                    }
//                }
//            }
//        }
//        .fullScreenCover(isPresented: $navigateToPayment) {
//            PaymentView {
//                // Called after successful purchase in first-launch flow
//                navigateToPayment = false                    // dismiss paywall sheet
//                //appViewModel.hasActiveSubscription = true    // mark active
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                    appViewModel.markFirstLaunchComplete()
//                    navigateToRegister = true
//                }
//            }
//        }
//        .fullScreenCover(isPresented: $navigateToRegister) {
//            RegisterView()
//        }
    }
}

//background: ;



#Preview {
    SplashScreenView()
        .environmentObject(AppViewModel())
        .environmentObject(PaymentViewModel())
}
