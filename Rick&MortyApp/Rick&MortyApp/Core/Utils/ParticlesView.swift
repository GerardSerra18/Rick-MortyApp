//
//  ParticlesView.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import SwiftUI

struct ParticlesView: View {
    
    @State private var random = UUID()

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<25, id: \.self) { _ in
                Circle()
                    .fill(Color.green.opacity(0.22))
                    .frame(width: CGFloat.random(in: 4...9))
                    .position(x: CGFloat.random(in: 0...geo.size.width), y: CGFloat.random(in: 0...geo.size.height))
                    .blur(radius: 2)
                    .animation(
                        .easeInOut(duration: Double.random(in: 3...6))
                        .repeatForever()
                        .delay(Double.random(in: 0...2)),
                        value: random )
            }
        }
        .onAppear { random = UUID() }
    }
}
