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
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                CharactersListView(viewModel: CharactersListViewModel(repo: repo))
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeOut(duration: 0.35)) {
                                    showSplash = false
                                }
                            }
                        }
                }
            }
        }
    }
}
