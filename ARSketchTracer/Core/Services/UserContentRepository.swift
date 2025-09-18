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
    func listUploads() async throws -> [Upload]
    func listGenerations() async throws -> [Generation]
    func listSavedSketches() async throws -> [SavedSketch]
}

final class UserContentRepositoryLive: UserContentRepository {
    private let supabaseClient = SupabaseManager.shared.client
    
    func uploadImage(data: Data, filename: String) async throws -> String {
        fatalError("unimplemented")
    }
    
    func saveSketch(path: String, sourceType: String, sourceId: String) async throws {
        fatalError("unimplemented")
    }
    
    func listUploads() async throws -> [Upload] {
        // TODO: Implement actual Supabase query for user uploads
        return []
    }
    
    func listGenerations() async throws -> [Generation] {
        // TODO: Implement actual Supabase query for user generations
        return []
    }
    
    func listSavedSketches() async throws -> [SavedSketch] {
        // TODO: Implement actual Supabase query for saved sketches
        return []
    }
}
