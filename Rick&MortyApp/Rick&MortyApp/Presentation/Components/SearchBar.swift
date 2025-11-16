//
//  SearchBar.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.cyan.opacity(0.85))
                .scaleEffect(isEditing ? 1.15 : 1)
                .animation(.easeInOut(duration: 0.2), value: isEditing)
            
            TextField("Search by name", text: $text, onEditingChanged: { editing in
                isEditing = editing
            })
            .foregroundColor(.white)
            .autocorrectionDisabled()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "10172B").opacity(0.75))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isEditing ? Color.cyan.opacity(0.7) : Color.cyan.opacity(0.35),
                                lineWidth: 1.4)
                        .shadow(color: Color.cyan.opacity(isEditing ? 0.8 : 0.3),
                                radius: isEditing ? 10 : 5)
                )
        )
        .animation(.easeInOut(duration: 0.25), value: isEditing)
    }
}
