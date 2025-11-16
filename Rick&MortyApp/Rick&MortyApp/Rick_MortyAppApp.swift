//
//  Rick_MortyAppApp.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import SwiftUI

@main
struct Rick_MortyAppApp: App {
    
    private let repo: CharactersRepositoryProtocol = CharactersRepository(apiClient: RickMortyAPIClient())
    
    var body: some Scene {
        WindowGroup {
            CharactersListView(viewModel: CharactersListViewModel(repo: repo))
        }
    }
}
