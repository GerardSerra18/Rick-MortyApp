//
//  CharactersRepository.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation

final class CharactersRepository: CharactersRepositoryProtocol {
    
    private let apiClient: RickMortyAPIClientProtocol
    private let cache: ResponseCache
    
    init(apiClient: RickMortyAPIClientProtocol, cache: ResponseCache = ResponseCache()) {
        self.apiClient = apiClient
        self.cache = cache
    }
    
    func getCharacters(page: Int, filters: CharactersFilter) async throws -> CharactersPage {
        let cacheKey = buildCacheKey(page: page, filters: filters)
        
        if let cachedDTO = cache.get(for: cacheKey) {
            return CharactersPage(dto: cachedDTO)
        }
        
        let dto = try await apiClient.fetchCharacters(page: page, name: filters.name, status: filters.status?.rawValue)
        
        cache.set(dto, for: cacheKey)
        
        return CharactersPage(dto: dto)
    }
    
    func getCharacter(id: Int) async throws -> Character {
        let dto = try await apiClient.fetchCharacter(id: id)
        return Character(dto: dto)
    }
    
    private func buildCacheKey(page: Int, filters: CharactersFilter) -> String {
        "page=\(page)&name=\(filters.name ?? "")&status=\(filters.status?.rawValue ?? "")"
    }
}
