//
//  CharactersListView.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import SwiftUI

struct CharactersListView: View {
    
    @StateObject private var viewModel: CharactersListViewModel
    private let imageCache = TemporaryImageCache()
    
    init(viewModel: CharactersListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Characters")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                    }
                }
                .portalBackground()
        }
        .refreshable {
            await viewModel.onRefresh()
        }
        .onChange(of: viewModel.searchText) {
            viewModel.onSearchChanged()
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

private extension CharactersListView {
    
    @ViewBuilder
    var content: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                SearchBar(text: $viewModel.searchText)
                    .padding(.top, 4)
                
                statusChips
                    .padding(.horizontal)
                
                switch viewModel.state {
                case .loading:
                    loadingView
                    
                case .error(let msg):
                    errorView(message: msg)
                    
                case .empty:
                    emptyView
                    
                case .loaded(let items):
                    listView(items: items)
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Views
private extension CharactersListView {
    
    var loadingView: some View {
        ProgressView("Loading...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var emptyView: some View {
        VStack(spacing: 12) {
            Text("No characters found")
                .font(.headline)
            Text("Try another search term")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Text(message)
                .font(.headline)
            Button("Retry") {
                viewModel.onAppear()
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    func listView(items: [Character]) -> some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 18
        ) {
            ForEach(items) { character in
                NavigationLink {
                    CharacterDetailView(characterID: character.id)
                } label: {
                    CharacterCard(character: character, cache: imageCache)
                }
                .buttonStyle(.plain)
                .onAppear {
                    viewModel.loadMoreIfNeeded(currentItem: character)
                }
            }
        }
    }
}

// MARK: - Filter
private extension CharactersListView {
    var statusChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                chip(title: "All", selected: viewModel.selectedStatus == nil) {
                    viewModel.selectedStatus = nil
                    viewModel.onStatusChanged()
                }
                
                ForEach([Character.Status.alive, .dead, .unknown], id: \.self) { status in
                    chip(title: status.rawValue, selected: viewModel.selectedStatus == status) {
                        viewModel.selectedStatus = status
                        viewModel.onStatusChanged()
                    }
                }
            }
            .padding(.horizontal)
            .scrollIndicators(.hidden)
        }
    }
    
    func chip(title: String, selected: Bool, action: @escaping () -> Void) -> some View {

        let baseColor: Color = {
            switch title.lowercased() {
            case "alive": return .green
            case "dead": return .red
            case "unknown": return .gray
            default: return .cyan
            }
        }()

        let glow = selected ? baseColor : baseColor.opacity(0.45)

        return Button(action: action) {
            Text(title)
                .font(.caption.bold())
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .foregroundColor(glow)
                .background(
                    Capsule()
                        .fill(Color(hex: "141B33").opacity(0.9))
                        .overlay(
                            Capsule()
                                .stroke(glow.opacity(0.65), lineWidth: selected ? 2 : 1)
                                .shadow(color: glow.opacity(0.8), radius: selected ? 6 : 2)
                        )
                )
                .animation(.easeOut(duration: 0.2), value: selected)
        }
    }
}
