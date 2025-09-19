//
//  ItemStyleVariant.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation

struct ItemStyleVariant: Decodable {
    let id: UUID
    let item_id: UUID
    let style_id: UUID
    let style_key: String?      // Style key for easier filtering
    let image_url: String?      // trace-ready image
    let overlay_url: String?
    let thumb_url: String?
    let hero_image_url: String?
    let trace_url: String?      // URL for tracing overlay
    let published: Bool
}
