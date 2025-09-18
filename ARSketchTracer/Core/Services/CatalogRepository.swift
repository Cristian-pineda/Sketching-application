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
}

final class CatalogRepositoryLive: CatalogRepository {
    private let supabaseClient = SupabaseManager.shared.client
    
    func fetchStyles() async throws -> [Style] {
        let response: [Style] = try await supabaseClient
            .from("styles")
            .select("id,key,name,description,sort_order")
            .order("sort_order")
            .execute()
            .value
        return response
    }
    
    func fetchCategories() async throws -> [Category] {
        let response: [Category] = try await supabaseClient
            .from("categories")
            .select("id,slug,name,description,thumb_url,published")
            .eq("published", value: true)
            .order("sort_order")
            .execute()
            .value
        return response
    }
    
    func fetchItems(categoryId: String, limit: Int?, styleKey: String?) async throws -> [Item] {
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
            return response
        }
    }
}
