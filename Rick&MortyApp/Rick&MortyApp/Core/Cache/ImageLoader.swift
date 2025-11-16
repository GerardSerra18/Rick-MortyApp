//
//  ImageLoader.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation
import SwiftUI

@MainActor
final class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    
    private let url: URL
    private var cache: ImageCache?
    private var task: Task<Void, Never>?
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    func load() {
        
        if let cached = cache?[url] {
            self.image = cached
            return
        }
        
        task = Task {
            do {
                let(data, _) = try await URLSession.shared.data(from: url)
                
                if let image = UIImage(data: data) {
                    cache?[url] = image
                    self.image = image
                }
            } catch {
                self.image = UIImage(systemName: "photo")
            }
        }
    }
    
    func cancel() {
        task?.cancel()
    }
}
