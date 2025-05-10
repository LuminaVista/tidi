//
//  SplashScreenView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 9/2/2025.
//

import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var navigate = false

    var body: some View {
        ZStack {
            Color(hex: "#DDD4C8")
                .ignoresSafeArea()
            Image("app_logo") // Replace "logo" with your image name
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
        }
        
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                navigate = true
            }
        }
    }
}

//background: ;



#Preview {
    SplashScreenView()
        .environmentObject(AppViewModel())
}
