//
//  StyleGalleryViewModel.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation

@MainActor
final class StyleGalleryViewModel: ObservableObject {
    @Published var entries: [(Item, ItemStyleVariant)] = []
    
    private let repo: CatalogRepository
    
    init(repo: CatalogRepository = CatalogRepositoryLive()) {
        self.repo = repo
    }
    
    func load(styleKey: String) async {
        do {
            self.entries = try await repo.fetchItemsByStyle(styleKey: styleKey)
        } catch {
            print("Failed to load style gallery:", error)
        }
    }
}
