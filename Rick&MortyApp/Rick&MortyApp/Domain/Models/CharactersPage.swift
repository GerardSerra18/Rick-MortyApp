//
//  CharactersPage.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation

struct CharactersPage {
    let items: [Character]
    let nextPage: Int?
}

extension CharactersPage {
    init(dto: CharactersPageDTO) {
        self.items = dto.results.map(Character.init)

        if
            let next = dto.info.next,
            let url = URL(string: next),
            let comps = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let page = comps.queryItems?.first(where: { $0.name == "page" })?.value,
            let pageValue = Int(page)
        {
            self.nextPage = pageValue
        } else {
            self.nextPage = nil
        }
    }
}
