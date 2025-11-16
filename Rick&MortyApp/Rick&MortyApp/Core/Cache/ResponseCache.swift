//
//  ResponseCache.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation

final class ResponseCache {
    
    private let cache = NSCache<NSString, CacheEntry>()
    
    final class CacheEntry {
        let value: CharactersPageDTO
        init(value: CharactersPageDTO) {
            self.value = value
        }
    }
    
    func get(for key: String) -> CharactersPageDTO? {
        cache.object(forKey: key as NSString)?.value
    }
    
    func set(_ value: CharactersPageDTO, for key: String) {
        cache.setObject(CacheEntry(value: value), forKey: key as NSString)
    }
}
