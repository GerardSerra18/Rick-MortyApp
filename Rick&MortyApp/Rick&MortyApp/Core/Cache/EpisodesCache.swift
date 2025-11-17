//
//  EpisodesCache.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 17/11/25.
//

import Foundation

final class EpisodesCache {
    
    private let cache = NSCache<NSString, EpisodeEntry>()
    
    final class EpisodeEntry {
        let value: EpisodeDTO
        init(value: EpisodeDTO) {
            self.value = value
        }
    }
    
    func get(for url: String) -> EpisodeDTO? {
        cache.object(forKey: url as NSString)?.value
    }
    
    func set(_ value: EpisodeDTO, for url: String) {
        cache.setObject(EpisodeEntry(value: value), forKey: url as NSString)
    }
}
