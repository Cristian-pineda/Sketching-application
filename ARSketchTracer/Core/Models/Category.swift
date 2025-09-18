//
//  Category.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation

struct Category: Decodable {
    let id: UUID
    let slug: String
    let name: String
    let description: String?
    let thumb_url: String?
    let published: Bool
}
