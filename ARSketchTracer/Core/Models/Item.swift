//
//  Item.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation

struct Item: Decodable, Identifiable {
    let id: UUID
    let name: String
    let slug: String
    let category_id: UUID
    let primary_style_id: UUID
    let hero_image_url: String
    let thumb_url: String?
    let published: Bool
}

// DTO for the view v_items_with_primary_variant
struct DashboardItemDTO: Decodable {
    let item_id: String
    let name: String
    let slug: String
    let category_id: String
    let style_key: String?
    let thumb_url: String?
    let trace_url: String?
    let hero_image_url: String?
}
