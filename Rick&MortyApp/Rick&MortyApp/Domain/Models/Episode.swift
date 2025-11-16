//
//  Episode.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation

struct Episode: Identifiable {
    let id: Int
    let name: String
    let code: String

    init(dto: EpisodeDTO) {
        self.id = dto.id
        self.name = dto.name
        self.code = dto.episode
    }
}
