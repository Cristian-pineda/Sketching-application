//
//  UserContentRepository.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Foundation

protocol UserContentRepository {
    func uploadImage(data: Data, filename: String) async throws -> String
    func saveSketch(path: String, sourceType: String, sourceId: String) async throws
}

final class UserContentRepositoryLive: UserContentRepository {
    private let supabaseClient = SupabaseManager.shared.client
    
    func uploadImage(data: Data, filename: String) async throws -> String {
        fatalError("unimplemented")
    }
    
    func saveSketch(path: String, sourceType: String, sourceId: String) async throws {
        fatalError("unimplemented")
    }
}
