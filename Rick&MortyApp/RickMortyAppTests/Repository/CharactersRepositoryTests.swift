//
//  CharactersRepositoryTests.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 17/11/25.
//

import Testing
@testable import Rick_MortyApp

struct CharactersRepositoryTests {

    @Test
    func test_getCharacter_ReturnsMappedCharacter() async throws {

        let mock = MockAPIClient()
        mock.mockCharacter = CharacterDTO(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", type: "", gender: "Male", image: "url", origin: LocationRefDTO(name: "Earth", url: ""), location: LocationRefDTO(name: "Citadel", url: ""), episode: ["S01E01", "S01E02", "S01E03"])

        let repo = CharactersRepository(apiClient: mock)

        let result = try await repo.getCharacter(id: 1)

        #expect(result.name == "Rick Sanchez")
        #expect(result.species == "Human")
    }


    @Test
    func test_getEpisodes_ReturnsSortedEpisodes() async throws {

        let mock = MockAPIClient()

        mock.mockEpisode = EpisodeDTO(id: 5,name: "Test Episode", episode: "S0E0")

        let repo = CharactersRepository(apiClient: mock)

        let episodes = try await repo.getEpisodes(urls: ["url1"])

        #expect(episodes.count == 1)
        #expect(episodes.first?.id == 5)
    }
}
