//
//  SearchViewModel.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation

struct CategorySection {
    let category: Category
    let items: [Item]
}

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var styles: [Style] = []
    @Published var sections: [CategorySection] = []
    
    private let catalogRepository: CatalogRepository
    
    init(catalogRepository: CatalogRepository = CatalogRepositoryLive()) {
        self.catalogRepository = catalogRepository
    }
    
    func load() async {
        do {
            // Load styles and categories concurrently
            async let stylesTask = catalogRepository.fetchStyles()
            async let categoriesTask = catalogRepository.fetchCategories()
            
            let (loadedStyles, loadedCategories) = await (try stylesTask, try categoriesTask)
            
            // Update styles on main thread
            styles = loadedStyles
            
            // For each category, fetch up to 8 items
            var categorySections: [CategorySection] = []
            
            for category in loadedCategories {
                do {
                    let items = try await catalogRepository.fetchItems(
                        categoryId: category.id.uuidString,
                        limit: 8,
                        styleKey: nil as String?
                    )
                    
                    let section = CategorySection(category: category, items: items)
                    categorySections.append(section)
                } catch {
                    // Continue processing other categories if one fails
                    print("Failed to load items for category \(category.name): \(error)")
                }
            }
            
            // Update sections on main thread
            sections = categorySections
            
        } catch {
            print("Failed to load styles or categories: \(error)")
        }
    }
}
