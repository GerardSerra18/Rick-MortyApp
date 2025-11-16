//
//  CharacterDetailView.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import SwiftUI

struct CharacterDetailView: View {
    
    @StateObject private var viewModel: CharacterDetailViewModel
    private let imageCache = TemporaryImageCache()
    
    init(characterID: Int) {
        let repo = CharactersRepository(apiClient: RickMortyAPIClient())
        _viewModel = StateObject(wrappedValue: CharacterDetailViewModel(characterID: characterID,
                                                                        repository: repo))
    }
    
    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .portalBackground()
            .transparentNavBar()
            .onAppear { viewModel.onAppear() }
    }
}

private extension CharacterDetailView {
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.white)
            
        case .error(let msg):
            VStack(spacing: 10) {
                Text(msg)
                Button("Retry") { viewModel.onAppear() }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .loaded(let character):
            detail(character)
        }
    }
    
    func detail(_ character: Character) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                
                RemoteImageView(url: character.imageURL, cache: imageCache)
                    .frame(width: 230, height: 230)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.cyan.opacity(0.7), lineWidth: 4)
                            .shadow(color: .cyan.opacity(1), radius: 18)
                    )
                    .shadow(color: .cyan.opacity(0.4), radius: 30)
                    .padding(.top, 30)
                
                Text(character.name)
                    .font(.system(size: 38, weight: .black))
                    .foregroundColor(.white)
                    .shadow(color: .cyan.opacity(0.7), radius: 8)
                    .multilineTextAlignment(.center)
                
                statusPill(character.status)
                
                VStack(spacing: 20) {
                    infoRow(title: "Species", value: character.species)
                    infoRow(title: "Gender", value: character.gender.rawValue)
                    infoRow(title: "Origin", value: character.originName)
                    infoRow(title: "Location", value: character.locationName)
                }
                .padding(.horizontal, 12)
                
                Spacer(minLength: 50)
            }
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Components
private extension CharacterDetailView {
    
    func statusPill(_ status: Character.Status) -> some View {
        let color = colorForStatus(status)
        
        return Text(status.rawValue)
            .font(.caption.bold())
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
            .background(color.opacity(0.22))
            .foregroundColor(color)
            .clipShape(Capsule())
            .shadow(color: color.opacity(0.8), radius: 6)
    }
    
    func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(title.uppercased())
                .font(.caption2.bold())
                .foregroundColor(.cyan.opacity(0.8))
                .shadow(color: .cyan.opacity(0.5), radius: 4)
            
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "11162A").opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.cyan.opacity(0.35), lineWidth: 1.3)
                )
                .shadow(
                    color: Color.cyan.opacity(0.25),
                    radius: 10, x: 0, y: 4
                )
        )
        .padding(.horizontal, 3)
    }
    
    func colorForStatus(_ status: Character.Status) -> Color {
        switch status {
        case .alive: return .green
        case .dead: return .red
        case .unknown: return .gray
        }
    }
}
