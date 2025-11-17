//
//  MockAPIClient.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 17/11/25.
//

import Foundation
import Testing
@testable import Rick_MortyApp

final class MockAPIClient: RickMortyAPIClientProtocol {

    var mockCharactersPage: CharactersPageDTO?
    var mockCharacter: CharacterDTO?
    var mockEpisode: EpisodeDTO?

    func fetchCharacters(page: Int, name: String?, status: String?) async throws -> CharactersPageDTO {
        guard let mockCharactersPage else {
            throw NetworkError.notFound
        }
        return mockCharactersPage
    }

    func fetchCharacter(id: Int) async throws -> CharacterDTO {
        guard let mockCharacter else {
            throw NetworkError.notFound
        }
        return mockCharacter
    }

    func fetchEpisode(url: String) async throws -> EpisodeDTO {
        guard let mockEpisode else {
            throw NetworkError.notFound
        }
        return mockEpisode
    }
}
