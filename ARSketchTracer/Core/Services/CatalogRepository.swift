//
//  CatalogRepository.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation
import Supabase

protocol CatalogRepository {
    func fetchStyles() async throws -> [Style]
    func fetchCategories() async throws -> [Category]
    func fetchItems(categoryId: String, limit: Int?, styleKey: String?) async throws -> [Item]
    func fetchDashboardItems() async throws -> [DashboardItemDTO]
    func fetchItemsByStyle(styleKey: String) async throws -> [(Item, ItemStyleVariant)]
}

final class CatalogRepositoryLive: CatalogRepository {
    private let supabaseClient = SupabaseManager.shared.client
    
    func fetchStyles() async throws -> [Style] {
        NSLog("🔗 CatalogRepository: Fetching styles from Supabase...")
        let response: [Style] = try await supabaseClient
            .from("styles")
            .select("id,key,name,description,sort_order")
            .order("sort_order")
            .execute()
            .value
        NSLog("🔗 CatalogRepository: Fetched \(response.count) styles")
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
    
    func fetchItems(categoryId: String, limit: Int?, styleKey: String?) async throws -> [Item] {
        NSLog("🔗 CatalogRepository: Fetching items for category \(categoryId), limit: \(String(describing: limit)), style: \(String(describing: styleKey))")
        if let styleKey = styleKey {
            // Join with item_style_variants and styles to filter by style key
            let query = supabaseClient
                .from("items")
                .select("id,category_id,slug,name,thumb_url,hero_image_url,published,item_style_variants!inner(style_id,styles!inner(key))")
                .eq("published", value: true)
                .eq("category_id", value: categoryId)
                .eq("item_style_variants.styles.key", value: styleKey)
            
            let finalQuery = if let limit = limit {
                query.limit(limit)
            } else {
                query
            }
            
            let response: [Item] = try await finalQuery.execute().value
            NSLog("🔗 CatalogRepository: Fetched \(response.count) items for category \(categoryId) with style \(styleKey)")
            return response
        } else {
            // Simple query without style filtering
            let query = supabaseClient
                .from("items")
                .select("id,category_id,slug,name,thumb_url,hero_image_url,published")
                .eq("published", value: true)
                .eq("category_id", value: categoryId)
            
            let finalQuery = if let limit = limit {
                query.limit(limit)
            } else {
                query
            }
            
            let response: [Item] = try await finalQuery.execute().value
            NSLog("🔗 CatalogRepository: Fetched \(response.count) items for category \(categoryId)")
            return response
        }
    }
    
    func fetchDashboardItems() async throws -> [DashboardItemDTO] {
        NSLog("🔗 CatalogRepository: Fetching dashboard items from view...")
        let response: [DashboardItemDTO] = try await supabaseClient
            .from("v_items_with_primary_variant")
            .select("*")
            .execute()
            .value
        NSLog("🔗 CatalogRepository: Fetched \(response.count) dashboard items")
        return response
    }
    
    func fetchItemsByStyle(styleKey: String) async throws -> [(Item, ItemStyleVariant)] {
        // Fetch items that have variants for the given style key
        let itemsResponse: [Item] = try await supabaseClient
            .from("items")
            .select("id,category_id,slug,name,description,thumb_url,hero_image_url,published,primary_style_id")
            .eq("published", value: true)
            .execute()
            .value
        
        // Fetch variants for the specific style
        let variantsResponse: [ItemStyleVariant] = try await supabaseClient
            .from("item_style_variants")
            .select("id,item_id,style_id,style_key,thumb_url,image_url,hero_image_url,overlay_url,trace_url")
            .eq("style_key", value: styleKey)
            .execute()
            .value
        
        // Match items with their variants
        var result: [(Item, ItemStyleVariant)] = []
        let variantsByItemId = Dictionary(grouping: variantsResponse) { $0.item_id }
        
        for item in itemsResponse {
            if let variants = variantsByItemId[item.id],
               let variant = variants.first {
                result.append((item, variant))
            }
        }
        
        return result
    }
}
