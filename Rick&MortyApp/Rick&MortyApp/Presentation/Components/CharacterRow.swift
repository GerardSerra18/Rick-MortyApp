//
//  CharacterRow.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import SwiftUI

struct CharacterRow: View {
    
    let character: Character
    let cache: ImageCache
    
    var body: some View {
        HStack(spacing: 14) {
            
            RemoteImageView(url: character.imageURL, cache: cache)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black.opacity(0.08), lineWidth: 1))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(character.name)
                    .font(.headline)
                
                Text(character.species)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                statusPill
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        .animation(.easeInOut(duration: 0.15), value: character.id)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    private var statusPill: some View {
        Text(character.status.rawValue)
            .font(.caption2)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(colorForStatus.opacity(0.2))
            .overlay(
                Capsule().stroke(colorForStatus.opacity(0.4), lineWidth: 0.6)
            )
            .foregroundColor(colorForStatus)
            .clipShape(Capsule())
    }
    
    private var colorForStatus: Color {
        switch character.status {
        case .alive: return .green
        case .dead: return .red
        case .unknown: return .gray
        }
    }
}
