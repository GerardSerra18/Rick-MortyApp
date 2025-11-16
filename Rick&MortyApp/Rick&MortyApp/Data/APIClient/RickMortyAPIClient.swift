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
        
        do {
            let (data, response) = try await URLSession.shared.data(from: components.url!)
            
            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            switch http.statusCode {
            case 200..<300:
                break
            case 404:
                throw NetworkError.notFound
            default:
                throw NetworkError.invalidStatusCode(http.statusCode)
            }
            
            do {
                return try JSONDecoder().decode(CharactersPageDTO.self, from: data)
            } catch {
                throw NetworkError.decoding
            }
        }
        catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                throw NetworkError.noInternet
            case .timedOut:
                throw NetworkError.timeout
            default:
                throw NetworkError.unknown
            }
        }
    }
    
    func fetchCharacter(id: Int) async throws -> CharacterDTO {
        
        let url = baseURL.appendingPathComponent("character/\(id)")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            switch http.statusCode {
            case 200..<300:
                break
            case 404:
                throw NetworkError.notFound
            default:
                throw NetworkError.invalidStatusCode(http.statusCode)
            }
            
            do {
                return try JSONDecoder().decode(CharacterDTO.self, from: data)
            } catch {
                throw NetworkError.decoding
            }
        }
        catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                throw NetworkError.noInternet
            case .timedOut:
                throw NetworkError.timeout
            default:
                throw NetworkError.unknown
            }
        }
    }
    
    func fetchEpisode(url: String) async throws -> EpisodeDTO {
        guard let episodeURL = URL(string: url) else { throw NetworkError.invalidURL }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: episodeURL)
            
            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            switch http.statusCode {
            case 200..<300: break
            case 404: throw NetworkError.notFound
            default: throw NetworkError.invalidStatusCode(http.statusCode)
            }
            
            return try JSONDecoder().decode(EpisodeDTO.self, from: data)
            
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet: throw NetworkError.noInternet
            case .timedOut: throw NetworkError.timeout
            default: throw NetworkError.unknown
            }
        }
    }
}

enum NetworkError: LocalizedError {
    case invalidStatusCode(Int)
    case decoding
    case noInternet
    case timeout
    case notFound
    case unknown
    case invalidURL

    var errorDescription: String? {
        switch self {
        case .invalidStatusCode(let code):
            return "Server error (\(code))."
        case .decoding:
            return "Failed to decode server response."
        case .noInternet:
            return "No internet connection."
        case .timeout:
            return "The request timed out."
        case .notFound:
            return "Character not found."
        case .unknown:
            return "Unknown error."
        case .invalidURL:
            return "Invalid URL"
        }
    }
}

