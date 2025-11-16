//
//  EpisodeDTO.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation

struct EpisodeDTO: Decodable {
    let id: Int
    let name: String
    let episode: String
}
