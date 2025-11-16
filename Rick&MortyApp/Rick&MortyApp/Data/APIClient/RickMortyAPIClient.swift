//
//  RickMortyAPIClient.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation

final class RickMortyAPIClient: RickMortyAPIClientProtocol {
    
    private let baseURL = URL(string:"https://rickandmortyapi.com/api")!
    
    func fetchCharacters(page: Int, name: String?, status: String?) async throws -> CharactersPageDTO {
        
        var components = URLComponents(url: baseURL.appendingPathComponent("character"), resolvingAgainstBaseURL: false)!
        
        var queryItems : [URLQueryItem] = [ URLQueryItem(name: "page", value: "\(page)")]
        
        if let name, !name.isEmpty {
            queryItems.append(.init(name: "name", value: name))
        }
        if let status, !status.isEmpty {
            queryItems.append(.init(name: "status", value: status))
        }
        components.queryItems = queryItems
        
        let (data, response) = try await URLSession.shared.data(from: components.url!)
        
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw NetworkError.invalidStatusCode
        }
        
        do {
            return try JSONDecoder().decode(CharactersPageDTO.self, from: data)
        } catch {
            throw NetworkError.decoding
        }
    }
    
    func fetchCharacter(id: Int) async throws -> CharacterDTO {
        
        let url = baseURL.appendingPathComponent("character/\(id)")
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw NetworkError.invalidStatusCode
        }
        
        do {
            return try JSONDecoder().decode(CharacterDTO.self, from: data)
        } catch {
            throw NetworkError.decoding
        }
    }
    
}

enum NetworkError: Error {
    case invalidStatusCode
    case decoding
    case noInternet
}
