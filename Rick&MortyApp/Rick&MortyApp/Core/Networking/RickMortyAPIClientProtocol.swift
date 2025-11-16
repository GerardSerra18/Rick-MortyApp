//
//  RickMortyAPIClientProtocol.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation

protocol RickMortyAPIClientProtocol {
    func fetchCharacters(page: Int, name: String?, status: String?) async throws -> CharactersPageDTO
    func fetchCharacter(id: Int) async throws -> CharacterDTO
}
