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
    let image_url: String?
    let overlay_url: String?
    let published: Bool
}
