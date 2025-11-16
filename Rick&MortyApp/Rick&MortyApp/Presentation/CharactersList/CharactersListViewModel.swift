//
//  CharactersListViewModel.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation

@MainActor
final class CharactersListViewModel: ObservableObject {
    
    //MARK: - Published State
    @Published private(set) var state: State = .loading
    @Published var searchText: String = ""
    @Published var selectedStatus: Character.Status? = nil
    
    //MARK: - Dependencies
    private let repo: CharactersRepositoryProtocol
    
    //MARK: - Pagination
    private var currentPage = 1
    private var canLoadMore = true
    private var isLoading = false
    
    // MARK: - State Enum
    enum State {
        case loading
        case loaded([Character])
        case empty
        case error(String)
    }
    
    
    init(repo: CharactersRepositoryProtocol) {
        self.repo = repo
    }
    
    
    func onAppear() {
        Task { await loadFirstPage() }
    }
    
    func onSearchChanged() {
        Task { await loadFirstPage() }
    }
    
    func onStatusChanged() {
        Task { await loadFirstPage() }
    }
    
    func loadMoreIfNeeded(currentItem: Character?) {
        guard case .loaded(let items) = state else { return }
        guard let currentItem = currentItem else { return }
        guard let last = items.last else { return }
        
        if last.id == currentItem.id {
            Task { await loadNextPage() }
        }
    }
    
    private func loadFirstPage() async {
        currentPage = 1
        canLoadMore = true
        state = .loading
        await loadPage(reset: true)
    }
    
    private func loadNextPage() async {
        guard canLoadMore, !isLoading else { return }
        await loadPage(reset: true)
    }
    
    private func loadPage(reset: Bool) async {
        isLoading = true
        
        do {
            let filters = CharactersFilter(name: searchText.isEmpty ? nil : searchText, status: selectedStatus)
            let page = try await repo.getCharacters(page: currentPage, filters: filters)
            
            if reset {
                state = page.items.isEmpty ? .empty : .loaded(page.items)
            } else {
                if case .loaded(let oldItems) = state {
                    let updated = oldItems + page.items
                    state = updated.isEmpty ? .empty : .loaded(updated)
                }
            }
            
            if let nextPage = page.nextPage {
                currentPage = nextPage
                canLoadMore = true
            } else {
                canLoadMore = false
            }
            
        } catch {
            state = .error("Error loading characters")
        }
        
        isLoading = false
    }
    
}
