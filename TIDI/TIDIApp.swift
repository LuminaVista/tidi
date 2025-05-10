//
//  TIDIApp.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 4/2/2025.
//

import SwiftUI

@main
struct TIDIApp: App {
//    var body: some Scene {
//        WindowGroup {
//            SplashScreenView()
//                .preferredColorScheme(.light)
//        }
//    }
    @StateObject var appViewModel = AppViewModel()

        var body: some Scene {
            WindowGroup {
                RootView()
                    .environmentObject(appViewModel)
                    .preferredColorScheme(.light)
            }
        }
}
