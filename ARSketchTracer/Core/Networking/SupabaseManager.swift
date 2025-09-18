//
//  SupabaseManager.swift
//  ARSketchTracer
//
//  Created by Cristian Pineda on 9/18/25.
//

import Supabase
import Foundation

final class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: "https://mtdfzpauhxkoshadpajk.supabase.co")!,
            supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im10ZGZ6cGF1aHhrb3NoYWRwYWprIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgyMDc1MzksImV4cCI6MjA3Mzc4MzUzOX0.GKnapG7JxxnkdALWqHDKsxVA3K-_OAJnUYoWqYO_AME"
        )
    }
}
