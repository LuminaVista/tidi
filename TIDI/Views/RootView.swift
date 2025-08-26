//
//  RootView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 10/5/2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else if appViewModel.isCheckingSubscription {
                // Show loading while checking subscription
                ZStack {
                    Color(hex: "#DDD4C8").ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Image("app_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 100)
                        
                        ProgressView()
                            .scaleEffect(1.2)
                        
                        Text("Checking subscription status...")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
            } else {
                if !appViewModel.hasActiveSubscription {
                    PaymentView()
                        .environmentObject(appViewModel) 
                }else{
                    if appViewModel.isLoggedIn {
                        HomeView(onLogout: {
                            appViewModel.logout()
                        })
                    } else {
                        if appViewModel.hasLaunchedBefore {
                            LoginView()
                                .environmentObject(appViewModel)
                        } else {
                            RegisterView()
                                .environmentObject(appViewModel)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppViewModel())
        .environmentObject(PaymentViewModel())
}
