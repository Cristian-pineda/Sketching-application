//
//  CategoryDetailViewModel.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation
import SwiftUI

@MainActor
final class CategoryDetailViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var styles: [Style] = []
    @Published var selectedStyleKey: String? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let category: Category
    private let catalogRepository: CatalogRepository
    
    init(category: Category, initialStyleKey: String? = nil, catalogRepository: CatalogRepository = CatalogRepositoryLive()) {
        self.category = category
        self.selectedStyleKey = initialStyleKey
        self.catalogRepository = catalogRepository
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let stylesTask = catalogRepository.fetchStyles()
            async let itemsTask = catalogRepository.fetchItems(
                categoryId: category.id.uuidString,
                limit: nil,
                styleKey: selectedStyleKey
            )
            
            let (fetchedStyles, fetchedItems) = try await (stylesTask, itemsTask)
            
            styles = fetchedStyles
            items = fetchedItems
        } catch {
            errorMessage = "Failed to load category data: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func selectStyle(_ styleKey: String?) async {
        guard selectedStyleKey != styleKey else { return }
        
        selectedStyleKey = styleKey
        await loadItems()
    }
    
    private func loadItems() async {
        isLoading = true
        
        do {
            items = try await catalogRepository.fetchItems(
                categoryId: category.id.uuidString,
                limit: nil,
                styleKey: selectedStyleKey
            )
        } catch {
            errorMessage = "Failed to load items: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    var categoryName: String {
        category.name
    }
    
    var hasStyles: Bool {
        !styles.isEmpty
    }
}
