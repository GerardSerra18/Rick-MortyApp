//
//  CharacterCard.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation
import SwiftUI

struct CharacterCard: View {
    
    @State private var appear = false

    let character: Character
    let cache: ImageCache
    
    var body: some View {
        VStack(spacing: 10) {
            
            RemoteImageView(url: character.imageURL, cache: cache)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.green.opacity(0.6), lineWidth: 3)
                        .shadow(color: Color.green.opacity(0.7), radius: 6)
                )
                .shadow(color: Color.green.opacity(0.35), radius: 10)
            
            Text(character.name)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text(character.species)
                .font(.subheadline)
                .foregroundColor(.cyan.opacity(0.8))

            statusPill(character.status)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(hex: "11162A").opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.cyan.opacity(0.25), lineWidth: 1)
                )
                .shadow(
                    color: Color.cyan.opacity(0.35),
                    radius: 8, x: 0, y: 4
                )
        )
        .scaleEffect(1)
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                appear = true
            }
        }
        .animation(.easeOut(duration: 0.25), value: character.id)
    }
}

// MARK: - STATUS PILL
private extension CharacterCard {
    
    func statusPill(_ status: Character.Status) -> some View {
        
        let color: Color = {
            switch status {
            case .alive: return .green
            case .dead: return .red
            case .unknown: return .gray
            }
        }()
        
        return Text(status.rawValue)
            .font(.caption2.bold())
            .padding(.vertical, 4)
            .padding(.horizontal, 10)
            .background(color.opacity(0.25))
            .foregroundColor(color)
            .clipShape(Capsule())
            .shadow(color: color.opacity(0.4), radius: 4)
    }
}
