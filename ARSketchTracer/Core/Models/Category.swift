//
//  Category.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation

struct Category: Decodable, Identifiable {
    let id: UUID
    let name: String
    let slug: String
    let description: String?
}
