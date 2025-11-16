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
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
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
        ScrollView {
            VStack(spacing: 20) {
                ZStack {
                    RemoteImageView(url: character.imageURL, cache: imageCache)
                        .blur(radius: 25)
                        .opacity(0.3)
                        .frame(height: 260)
                        .clipped()
                    
                    RemoteImageView(url: character.imageURL, cache: imageCache)
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .shadow(radius: 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )
                }
                .frame(height: 260)
                .padding(.top, -20)
                
                Text(character.name)
                    .font(.largeTitle.bold())
                
                statusPill(character.status)
                
                VStack(spacing: 12) {
                    infoRow(title: "Species", value: character.species)
                    infoRow(title: "Gender", value: character.gender.rawValue)
                    infoRow(title: "Origin", value: character.originName)
                    infoRow(title: "Location", value: character.locationName)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
    }
}

// MARK: - Components
private extension CharacterDetailView {
    
    func statusPill(_ status: Character.Status) -> some View {
        Text(status.rawValue)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(colorForStatus(status).opacity(0.2))
            .foregroundColor(colorForStatus(status))
            .clipShape(Capsule())
    }
    
    func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    func colorForStatus(_ status: Character.Status) -> Color {
        switch status {
        case .alive: return .green
        case .dead: return .red
        case .unknown: return .gray
        }
    }
}
