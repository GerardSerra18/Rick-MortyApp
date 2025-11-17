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
    private let episodesCache: EpisodesCache
    
    init(apiClient: RickMortyAPIClientProtocol, cache: ResponseCache = ResponseCache(), episodesCache: EpisodesCache = EpisodesCache()) {
        self.apiClient = apiClient
        self.cache = cache
        self.episodesCache = episodesCache
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
    
    func getEpisodes(urls: [String]) async throws -> [Episode] {
        
        return try await withThrowingTaskGroup(of: Episode.self) { group in
            
            for url in urls {
                group.addTask { [weak self] in
                    
                    guard let self = self else { throw NetworkError.unknown }
                    
                    if let cached = self.episodesCache.get(for: url) {
                        return Episode(dto: cached)
                    }
                    
                    let dto = try await self.apiClient.fetchEpisode(url: url)
                    self.episodesCache.set(dto, for: url)
                    
                    return Episode(dto: dto)
                }
            }
            
            var episodes: [Episode] = []
            
            for try await episode in group {
                episodes.append(episode)
            }
            
            return episodes.sorted { $0.id < $1.id }
        }
    }
}
