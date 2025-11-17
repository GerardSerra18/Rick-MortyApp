//
//  CharactersListViewModelTests.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 17/11/25.
//

@testable import Rick_MortyApp
import Testing

struct CharactersListViewModelTests {

    @Test
    func test_loadCharacters_success() async throws {
        let repo = MockCharactersRepository()
        repo.mockPage = CharactersPage(dto: CharactersPageDTO(info: InfoDTO(count: 1, pages: 1, next: nil, prev: nil), results: []))

        let vm = await CharactersListViewModel(repo: repo)

        await vm.test_loadCharacters()

        await #expect(vm.state == .empty)
    }
}
