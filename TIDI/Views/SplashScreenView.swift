//
//  SplashScreenView.swift
//  TIDI
//
//  Created by Shafayet Ul Islam on 9/2/2025.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false  // Controls navigation
    
    
    var body: some View {
        if isActive {
            RegisterView()  // Navigate to RegisterView after tap
        }else{
            VStack {
                Image("app_logo")  // Add your logo to Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Text("Tap to start")
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(hex: "#DDD4C8")
                .edgesIgnoringSafeArea(.all)
            )
            .onTapGesture {
                isActive = true  // Trigger transition on tap
            }
        }
    }
}

//background: ;



#Preview {
    SplashScreenView()
}
