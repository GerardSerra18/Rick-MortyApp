//
//  CharactersPageDTO.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation

struct CharactersPageDTO: Decodable {
    let info: InfoDTO
    let results: [CharacterDTO]
}
