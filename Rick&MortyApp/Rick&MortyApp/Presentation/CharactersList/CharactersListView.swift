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
                .navigationTitle("Characters")
        }
        .searchable(text: $viewModel.searchText, prompt: "Search by name")
        .onChange(of: viewModel.searchText) { _ in
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
        List {
            statusChips

            ForEach(items) { character in
                NavigationLink {
                    CharacterDetailView(characterID: character.id)
                } label: {
                    CharacterRow(character: character, cache: imageCache)
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: character)
                        }
                }
            }
        }
        .listStyle(.plain)
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
            .padding(.vertical, 6)
        }
    }
    
    func chip(title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(selected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.15))
                .foregroundColor(selected ? .blue : .primary)
                .clipShape(Capsule())
        }
    }
}
