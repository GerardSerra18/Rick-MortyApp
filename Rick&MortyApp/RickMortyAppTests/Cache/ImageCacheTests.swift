//
//  ImageCacheTests.swift
//  Rick&MortyApp
//
//  Created by Gerard Serra Rodriguez on 17/11/25.
//

import Foundation
@testable import Rick_MortyApp
import Testing
import SwiftUI

struct ImageCacheTests {

    @Test
    func testImageCacheStoresAndRetrievesImages() async throws {
        let cache = TemporaryImageCache()

        let img = UIImage(systemName: "star")

        cache[URL(string: "https://test.com")!] = img

        let result = cache[URL(string: "https://test.com")!]

        #expect(result != nil)
    }
}
