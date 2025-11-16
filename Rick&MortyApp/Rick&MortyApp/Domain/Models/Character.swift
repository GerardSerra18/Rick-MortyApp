//
//  Character.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation

struct Character: Identifiable, Equatable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let gender: Gender
    let imageURL: URL?
    let originName: String
    let locationName: String

    enum Status: String {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
    }

    enum Gender: String {
        case female = "Female"
        case male = "Male"
        case genderless = "Genderless"
        case unknown = "unknown"
    }
}

extension Character {
    init(dto: CharacterDTO) {
        self.id = dto.id
        self.name = dto.name
        self.species = dto.species
        self.imageURL = URL(string: dto.image)
        self.originName = dto.origin.name
        self.locationName = dto.location.name

        self.status = Character.Status(rawValue: dto.status) ?? .unknown
        self.gender = Character.Gender(rawValue: dto.gender) ?? .unknown
    }
}
