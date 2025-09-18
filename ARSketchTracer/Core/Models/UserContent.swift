//
//  UserContent.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation

// MARK: - Upload Model

struct Upload: Decodable {
    let id: UUID
    let filename: String
    let url: String
    let uploadedAt: Date
    let userId: UUID?
}

// MARK: - Generation Model

struct Generation: Decodable {
    let id: UUID
    let prompt: String
    let imageUrl: String
    let createdAt: Date
    let status: String
    let userId: UUID?
}

// MARK: - Saved Sketch Model

struct SavedSketch: Decodable {
    let id: UUID
    let name: String
    let imagePath: String
    let sourceType: String // "upload", "generation", or "catalog"
    let sourceId: String
    let createdAt: Date
    let userId: UUID?
}
