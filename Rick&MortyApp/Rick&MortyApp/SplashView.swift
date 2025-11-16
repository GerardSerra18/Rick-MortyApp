//
//  SplashView.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 0.0
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            
            LinearGradient(colors: [Color(hex: "0E1225"), Color(hex: "1C2446")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ParticlesView()
                .opacity(0.5)
            
            Image("Splash")
                .resizable()
                .scaledToFit()
                .frame(width: 240)
                .scaleEffect(scale)
                .opacity(opacity)
                .rotationEffect(.degrees(rotation))
                .shadow(color: .cyan.opacity(0.7), radius: 25)
                .onAppear {
                    withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
                        scale = 1.0
                        opacity = 1.0
                    }
                    withAnimation(.easeOut(duration: 1.2)) {
                        rotation = 720
                    }
                }
        }
    }
}
