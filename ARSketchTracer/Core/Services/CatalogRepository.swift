//
//  CatalogRepository.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation
import Supabase

protocol CatalogRepository {
    func fetchAllStyles() async throws -> [Style]
    func fetchCategories() async throws -> [Category]
    func fetchItems(categoryId: String, limit: Int?, styleId: String?) async throws -> [Item]
    func fetchItemsByStyle(styleKey: String) async throws -> [Item]
}

final class CatalogRepositoryLive: CatalogRepository {
    private let supabaseClient = SupabaseManager.shared.client
    
    /// Fetch all global styles (not scoped by category)
    func fetchAllStyles() async throws -> [Style] {
        NSLog("🔗 CatalogRepository: Fetching all global styles from Supabase...")
        let response: [Style] = try await supabaseClient
            .from("styles")
            .select("id,name,key")
            .order("name", ascending: true)
            .execute()
            .value
        NSLog("🔗 CatalogRepository: ✅ Successfully fetched \(response.count) styles")
        return response
    }
    
    func fetchCategories() async throws -> [Category] {
        NSLog("🔗 CatalogRepository: Fetching categories from Supabase...")
        let response: [Category] = try await supabaseClient
            .from("categories")
            .select("id,slug,name,description,thumb_url,published")
            .eq("published", value: true)
            .order("sort_order")
            .execute()
            .value
        NSLog("🔗 CatalogRepository: Fetched \(response.count) categories")
        return response
    }
    
    func fetchItems(categoryId: String, limit: Int?, styleId: String?) async throws -> [Item] {
        NSLog("🔗 CatalogRepository: Fetching items for category \(categoryId), limit: \(String(describing: limit)), styleId: \(String(describing: styleId))")
        
        do {
            var query = supabaseClient
                .from("items")
                .select("id,name,slug,category_id,primary_style_id,hero_image_url,thumb_url,published")
                .eq("category_id", value: categoryId)
                .eq("published", value: true)
            
            // Filter by style if provided
            if let styleId = styleId {
                query = query.eq("primary_style_id", value: styleId)
            }
            
            // Apply limit if provided and execute query
            let response: [Item] = if let limit = limit {
                try await query.limit(limit).execute().value
            } else {
                try await query.execute().value
            }
            
            NSLog("🔗 CatalogRepository: ✅ Successfully fetched \(response.count) items for category \(categoryId)")
            return response
            
        } catch {
            NSLog("❌ CatalogRepository: Error fetching items for category \(categoryId): \(error)")
            throw error
        }
    }
    
    func fetchItemsByStyle(styleKey: String) async throws -> [Item] {
        NSLog("🔗 CatalogRepository: Fetching all items for style key: \(styleKey)")
        
        // First, get the style ID from the style key
        let styles: [Style] = try await supabaseClient
            .from("styles")
            .select("id,name,key")
            .eq("key", value: styleKey)
            .execute()
            .value
        
        guard let style = styles.first else {
            NSLog("❌ CatalogRepository: No style found for key: \(styleKey)")
            return []
        }
        
        // Then fetch items that use this style as their primary style
        let items: [Item] = try await supabaseClient
            .from("items")
            .select("id,name,slug,category_id,primary_style_id,hero_image_url,thumb_url,published")
            .eq("published", value: true)
            .eq("primary_style_id", value: style.id.uuidString)
            .execute()
            .value
        
        NSLog("🔗 CatalogRepository: Found \(items.count) items for style \(styleKey)")
        return items
    }
}
