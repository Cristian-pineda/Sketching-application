//
//  SearchViewModel.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation
import SwiftUI

struct CategorySection {
    let category: Category
    let items: [Item]
}

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var styles: [Style] = []
    @Published var sections: [CategorySection] = []
    @Published var selectedStyleKey: String? = CatalogRepositoryLive.defaultStyleKey
    @Published var isLoading = false
    
    private let catalogRepository: CatalogRepository
    private var allCategories: [Category] = []
    
    init(catalogRepository: CatalogRepository = CatalogRepositoryLive()) {
        self.catalogRepository = catalogRepository
    }
    
    func load() async {
        print("✅ SearchViewModel.load called")
        NSLog("🔄 SearchViewModel: Starting data load...")
        isLoading = true
        
        do {
            // Load styles and categories concurrently
            async let stylesTask = catalogRepository.fetchAllStyles()
            async let categoriesTask = catalogRepository.fetchCategories()
            
            let loadedStyles = try await stylesTask
            let loadedCategories = try await categoriesTask
            
            NSLog("📊 SearchViewModel: Loaded \(loadedStyles.count) styles, \(loadedCategories.count) categories")
            
            // Update styles on main thread
            styles = loadedStyles
            allCategories = loadedCategories
            
            // Load items for categories with current filter
            await loadCategorySections()
            
        } catch {
            NSLog("❌ Failed to load styles or categories: \(error)")
        }
        
        isLoading = false
    }
    
    func selectStyle(_ styleKey: String?) async {
        // Don't toggle - always set the selection (radio button behavior)
        // Only change if it's actually different
        guard selectedStyleKey != styleKey else { return }
        
        selectedStyleKey = styleKey
        NSLog("🎨 SearchViewModel: Style filter changed to: \(styleKey ?? CatalogRepositoryLive.defaultStyleKey)")
        
        // Reload category sections with new filter
        await loadCategorySections()
    }
    
    private func loadCategorySections() async {
        isLoading = true
        var categorySections: [CategorySection] = []
        
        for category in allCategories {
            do {
                let items = try await catalogRepository.fetchItems(
                    categoryId: category.id.uuidString,
                    limit: 8,
                    styleKey: selectedStyleKey
                )
                
                NSLog("📦 SearchViewModel: Category '\(category.name)' has \(items.count) items")
                let section = CategorySection(category: category, items: items)
                categorySections.append(section)
            } catch {
                // Continue processing other categories if one fails
                NSLog("❌ Failed to load items for category \(category.name): \(error)")
            }
        }
        
        // Update sections on main thread
        sections = categorySections
        NSLog("✅ SearchViewModel: Updated sections array with \(sections.count) sections")
        isLoading = false
    }
}
