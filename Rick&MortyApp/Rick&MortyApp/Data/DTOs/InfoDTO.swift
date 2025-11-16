//
//  InfoDTO.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation

struct InfoDTO: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
