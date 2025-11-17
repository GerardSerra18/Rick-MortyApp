//
//  RickMortyAPIClientTests.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 17/11/25.
//

@testable import Rick_MortyApp
import Testing

struct RickMortyAPIClientTests {

    @Test
    func testInvalidCharacterURLThrowsInvalidURL() async throws {
        let client = RickMortyAPIClient()

        do {
            _ = try await client.fetchEpisode(url: "Invalid URL")
            Issue.record("Expected error not thrown")
        } catch {
            #expect(error is NetworkError)
        }
    }
}
