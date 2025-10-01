//
//  Item.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation

/// Represents a published catalog item variant paired with its parent item metadata.
struct Item: Identifiable {
    /// Unique identifier for the item variant (primary key on item_style_variants).
    let id: UUID
    /// Identifier of the parent item (items.id).
    let itemId: UUID
    let name: String
    let slug: String
    let categoryId: UUID
    let tracePath: String
    let description: String?
    let tags: [String]
    let difficulty: Int?
    let styleId: UUID?
    let styleKey: String?
    let createdAt: String
}

extension Item {
    init(row: CatalogItemVariantRow) {
        id = row.id
        itemId = row.items.id
        name = row.items.name
        slug = row.items.slug
        categoryId = row.items.categoryId
        tracePath = row.tracePath
        description = row.description
        tags = row.tags ?? []
        difficulty = row.difficulty
        styleId = row.styleId
        styleKey = row.styles?.key
        createdAt = row.createdAt
    }
}

/// Raw response payload for a variant joined with its parent item.
struct CatalogItemVariantRow: Decodable {
    struct ItemDetails: Decodable {
        let id: UUID
        let name: String
        let slug: String
        let categoryId: UUID

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case slug
            case categoryId = "category_id"
        }
    }

    struct StyleDetails: Decodable {
        let key: String
    }

    let id: UUID
    let tracePath: String
    let description: String?
    let tags: [String]?
    let difficulty: Int?
    let styleId: UUID?
    let createdAt: String
    let items: ItemDetails
    let styles: StyleDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case tracePath = "trace_path"
        case description
        case tags
        case difficulty
        case styleId = "style_id"
        case createdAt = "created_at"
        case items
        case styles
    }
}
