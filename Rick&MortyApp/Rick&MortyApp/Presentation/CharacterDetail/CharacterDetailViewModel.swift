//
//  CharacterDetailViewModel.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation

@MainActor
final class CharacterDetailViewModel: ObservableObject {
    
    @Published private(set) var state: State = .loading
    
    private let repository: CharactersRepositoryProtocol
    private let characterID: Int
    
    init(characterID: Int, repository: CharactersRepositoryProtocol) {
        self.characterID = characterID
        self.repository = repository
    }
    
    enum State {
        case loading
        case loaded(Character, [Episode])
        case error(String)
    }
    
    func onAppear() {
        Task { await loadCharacter() }
    }
    
    private func loadCharacter() async {
        state = .loading
        
        do {
            let character = try await repository.getCharacter(id: characterID)
            let episodes = try await repository.getEpisodes(urls: character.episodeURLs)
            state = .loaded(character, episodes)
        } catch let error as NetworkError {
            state = .error(error.errorDescription ?? "Unknown error")
        } catch {
            state = .error("Unexpected error")
        }
    }
    
    
    // MARK: - Testing
    #if DEBUG
    @MainActor
    func test_loadCharacter() async {
        await loadCharacter()
    }
    #endif

}
