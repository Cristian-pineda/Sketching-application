//
//  Style.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation

struct Style: Decodable, Identifiable {
    let id: UUID
    let name: String
    let key: String
}
