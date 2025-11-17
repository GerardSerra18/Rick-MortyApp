//
//  MockCharactersRepository.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 17/11/25.
//

@testable import Rick_MortyApp

final class MockCharactersRepository: CharactersRepositoryProtocol {
    
    var mockPage: CharactersPage?
    var mockCharacter: Character?
    var mockEpisodes: [Episode] = []

    func getCharacters(page: Int, filters: CharactersFilter) async throws -> CharactersPage {
        guard let mockPage else { throw NetworkError.notFound }
        return mockPage
    }

    func getCharacter(id: Int) async throws -> Character {
        guard let mockCharacter else { throw NetworkError.notFound }
        return mockCharacter
    }

    func getEpisodes(urls: [String]) async throws -> [Episode] {
        return mockEpisodes
    }
}
