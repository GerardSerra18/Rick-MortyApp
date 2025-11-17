//
//  CharacterDetailViewModelTests.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 17/11/25.
//

@testable import Rick_MortyApp
import Testing
import Foundation

struct CharacterDetailViewModelTests {
    
    @Test
    func test_loadCharacter_success() async throws {
        let repo = MockCharactersRepository()
        
        repo.mockCharacter = Character(id: 1, name: "Morty", status: .alive, species: "Human", gender: .male, imageURL: URL(string:"https://test.com")!, originName: "Earth", locationName: "Earth", episodeURLs: ["https://example.com/ep1"])
        
        repo.mockEpisodes = [Episode(dto: EpisodeDTO(id: 1, name: "Pilot", episode: "S01E01"))]
        
        let vm = await CharacterDetailViewModel(characterID: 1, repository: repo)
        
        await vm.test_loadCharacter()
        
        switch await vm.state {
        case .loaded(let c, let eps):
            #expect(c.name == "Morty")
            #expect(eps.count == 1)
            #expect(eps.first?.name == "Pilot")
        default:
            #expect(Bool(false), "Expected loaded state")
        }
    }
}
