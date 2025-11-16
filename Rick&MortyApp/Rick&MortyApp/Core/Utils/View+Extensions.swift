//
//  View+Extensions.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation
import SwiftUI

extension View {
    func portalBackground() -> some View {
        self.background(
            ZStack {
                LinearGradient(
                    colors: [
                        Color(hex: "0A0E23"),
                        Color(hex: "0C1333")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                Circle()
                    .fill(Color.green.opacity(0.18))
                    .frame(width: 520, height: 520)
                    .blur(radius: 90)
                    .offset(x: -120, y: -260)
                
                Circle()
                    .fill(Color.cyan.opacity(0.18))
                    .frame(width: 420, height: 420)
                    .blur(radius: 85)
                    .offset(x: 140, y: 200)
                
                ParticlesView()
            }
            .ignoresSafeArea()
        )
    }
}
