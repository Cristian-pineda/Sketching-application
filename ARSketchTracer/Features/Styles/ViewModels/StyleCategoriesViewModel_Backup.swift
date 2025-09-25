//
//  StyleCategoriesViewModel.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/25/25.
//

import Foundation

struct CategoryWithItemCount {
    let category: Category
    let itemCount: Int
}

@MainActor
final class StyleCategoriesViewModel: ObservableObject {
    @Published var categoriesWithItems: [CategoryWithItemCount] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let catalogRepository: CatalogRepository
    
    init(catalogRepository: CatalogRepository = CatalogRepositoryLive()) {
        self.catalogRepository = catalogRepository
    }
    
    func loadCategoriesForStyle(styleKey: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            NSLog("🎨 StyleCategoriesViewModel: Loading categories for style: \(styleKey)")
            
            // First, get the style ID from the style key
            let allStyles = try await catalogRepository.fetchAllStyles()
            guard let targetStyle = allStyles.first(where: { $0.key == styleKey }) else {
                errorMessage = "Style not found: \(styleKey)"
                isLoading = false
                return
            }
            let styleId = targetStyle.id.uuidString
            
            // Then get all categories
            let allCategories = try await catalogRepository.fetchCategories()
            NSLog("🎨 StyleCategoriesViewModel: Fetched \(allCategories.count) total categories")
            
            // For each category, check how many items it has with this style
            var categoriesWithItemCounts: [CategoryWithItemCount] = []
            
            for category in allCategories {
                do {
                    let items = try await catalogRepository.fetchItems(
                        categoryId: category.id.uuidString,
                        limit: nil,
                        styleId: styleId
                    )
                    
                    if !items.isEmpty {
                        let categoryData = CategoryWithItemCount(
                            category: category,
                            itemCount: items.count
                        )
                        categoriesWithItemCounts.append(categoryData)
                        NSLog("🎨 StyleCategoriesViewModel: Category '\(category.name)' has \(items.count) items with style \(styleKey)")
                    } else {
                        NSLog("🎨 StyleCategoriesViewModel: Category '\(category.name)' has no items with style \(styleKey)")
                    }
                } catch {
                    NSLog("❌ StyleCategoriesViewModel: Failed to fetch items for category '\(category.name)': \(error)")
                    // Continue with other categories instead of failing completely
                }
            }
            
            // Sort by item count (descending) then by name
            categoriesWithItems = categoriesWithItemCounts.sorted { lhs, rhs in
                if lhs.itemCount == rhs.itemCount {
                    return lhs.category.name < rhs.category.name
                }
                return lhs.itemCount > rhs.itemCount
            }
            
            NSLog("🎨 StyleCategoriesViewModel: Found \(categoriesWithItems.count) categories with items in style \(styleKey)")
            
        } catch {
            errorMessage = "Failed to load categories for style: \(error.localizedDescription)"
            NSLog("❌ StyleCategoriesViewModel: Error loading categories: \(error)")
        }
        
        isLoading = false
    }
}
