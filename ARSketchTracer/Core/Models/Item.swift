//
//  Item.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation

struct Item: Decodable {
    let id: UUID
    let category_id: UUID
    let slug: String
    let name: String
    let description: String?
    let thumb_url: String?
    let hero_image_url: String?
    let published: Bool
    let primary_style_id: String?
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
