//
//  RemoteImageView.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 16/11/25.
//

import Foundation
import SwiftUI

struct RemoteImageView: View {
    
    @StateObject private var loader: ImageLoader
    
    init(url: URL?, cache: ImageCache? = nil) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url ?? URL(string: "https://")!, cache: cache)) //just a fallback
    }
    
    var body: some View {
        content
            .onAppear { loader.load()}
            .onDisappear { loader.cancel()}
    }
    
    @ViewBuilder
    private var content: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .transition(.opacity.animation(.easeIn(duration: 0.25)))
        } else {
            ProgressView()
        }
    }
}
