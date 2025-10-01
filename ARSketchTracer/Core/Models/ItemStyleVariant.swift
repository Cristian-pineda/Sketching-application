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
    let trace_path: String?     // Storage path for the variant asset
    let published: Bool
}
