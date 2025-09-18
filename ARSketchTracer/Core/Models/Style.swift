//
//  Style.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation

struct Style: Decodable {
    let id: UUID
    let key: String
    let name: String
    let description: String?
    let sort_order: Int?
}
