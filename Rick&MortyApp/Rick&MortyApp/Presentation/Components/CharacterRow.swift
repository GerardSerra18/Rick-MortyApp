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
        HStack(spacing: 12) {
            
            RemoteImageView(url: character.imageURL, cache: cache)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text(character.name)
                    .font(.headline)
                
                Text(character.species)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                statusPill
            }
        }
        .padding(.vertical, 8)
    }
    
    private var statusPill: some View {
        Text(character.status.rawValue)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(colorForStatus.opacity(0.2))
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
