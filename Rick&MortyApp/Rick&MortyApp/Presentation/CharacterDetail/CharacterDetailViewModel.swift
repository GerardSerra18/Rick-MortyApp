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
        case loaded(Character)
        case error(String)
    }
    
    func onAppear() {
        Task { await loadCharacter() }
    }
    
    private func loadCharacter() async {
        state = .loading
        
        do {
            let character = try await repository.getCharacter(id: characterID)
            state = .loaded(character)
        } catch {
            state = .error("Error loading character")
        }
    }
}
