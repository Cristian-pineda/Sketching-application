//
//  CatalogRepository.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation
import Supabase
import PostgREST

protocol CatalogRepository {
    func fetchAllStyles() async throws -> [Style]
    func fetchCategories() async throws -> [Category]
    func fetchItems(categoryId: String, limit: Int?, styleKey: String?) async throws -> [Item]
    func fetchItemsByStyle(styleKey: String) async throws -> [Item]
}

final class CatalogRepositoryLive: CatalogRepository {
    static let defaultStyleKey = "line-art"
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
            .select("id,slug,name,description")
            .eq("published", value: true)
            .order("name", ascending: true)
            .execute()
            .value
        NSLog("🔗 CatalogRepository: Fetched \(response.count) categories")
        return response
    }
    
    func fetchItems(categoryId: String, limit: Int?, styleKey: String?) async throws -> [Item] {
        let resolvedStyleKey = styleKey ?? Self.defaultStyleKey
        NSLog("🔗 CatalogRepository: Fetching items for category \(categoryId), limit: \(String(describing: limit)), styleKey: \(resolvedStyleKey)")

        let selectClause = """
        id,
        trace_path,
        description,
        tags,
        difficulty,
        style_id,
        created_at,
        items!inner (
            id,
            name,
            slug,
            category_id
        ),
        styles!inner (
            key
        )
        """

        var query = supabaseClient
            .from("item_style_variants")
            .select(selectClause)
            .eq("published", value: true)
            .eq("items.published", value: true)
            .eq("items.category_id", value: categoryId)
            .eq("styles.key", value: resolvedStyleKey)
            .order("created_at", ascending: false)

        if let limit {
            query = query.limit(limit)
        }

        do {
            let rows: [CatalogItemVariantRow] = try await query.execute().value
            let items = rows.map(Item.init)
            NSLog("🔗 CatalogRepository: ✅ Successfully fetched \(items.count) items for category \(categoryId)")
            return items
        } catch {
            NSLog("❌ CatalogRepository: Error fetching items for category \(categoryId): \(error)")
            throw error
        }
    }
    
    func fetchItemsByStyle(styleKey: String) async throws -> [Item] {
        NSLog("🔗 CatalogRepository: Fetching all items for style key: \(styleKey)")

        let selectClause = """
        id,
        trace_path,
        description,
        tags,
        difficulty,
        style_id,
        created_at,
        items!inner (
            id,
            name,
            slug,
            category_id
        ),
        styles!inner (
            key
        )
        """

        do {
            let rows: [CatalogItemVariantRow] = try await supabaseClient
                .from("item_style_variants")
                .select(selectClause)
                .eq("published", value: true)
                .eq("items.published", value: true)
                .eq("styles.key", value: styleKey)
                .order("created_at", ascending: false)
                .execute()
                .value

            let items = rows.map(Item.init)
            NSLog("🔗 CatalogRepository: Found \(items.count) items for style \(styleKey)")
            return items
        } catch {
            NSLog("❌ CatalogRepository: Error fetching items for style \(styleKey): \(error)")
            throw error
        }
    }
}
