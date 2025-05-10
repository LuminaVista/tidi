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
            } else {
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

#Preview {
    RootView()
        .environmentObject(AppViewModel())
}
