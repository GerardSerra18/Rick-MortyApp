//
//  CharactersRepositoryProtocol.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation

protocol CharactersRepositoryProtocol {
    func getCharacters(page: Int, filters: CharactersFilter) async throws -> CharactersPage
    func getCharacter(id: Int) async throws -> Character
    func getEpisodes(urls: [String]) async throws -> [Episode]
}
