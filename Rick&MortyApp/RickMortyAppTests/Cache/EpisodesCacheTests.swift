//
//  EpisodesCacheTests.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 17/11/25.
//

import Testing
@testable import Rick_MortyApp

struct EpisodesCacheTests {

    @Test
    func testEpisodesCacheStoresAndRetrievesEpisodes() async throws {
        let cache = EpisodesCache()

        let ep1 = EpisodeDTO(id: 1, name: "Pilot", episode: "S01E01")
        let ep2 = EpisodeDTO(id: 2, name: "Ep2", episode: "S01E02")

        cache.set(ep1, for: "1")
        cache.set(ep2, for: "2")

        #expect(cache.get(for: "1")?.id == 1)
        #expect(cache.get(for: "2")?.id == 2)
        #expect(cache.get(for: "3") == nil)
    }
}
