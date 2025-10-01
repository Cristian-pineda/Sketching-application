//
//  Supabase+PublicURL.swift
//  ARSketchTracer
//
//  Created by Codex on 10/11/25.
//

import Foundation
import Supabase

extension SupabaseClient {
    /// Builds a public URL for a given image path stored in the catalog bucket.
    func publicImageURL(from tracePath: String?, inBucket bucket: String = "catalog") -> URL? {
      guard let tracePath else { return nil }
      let trimmed = tracePath.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !trimmed.isEmpty else { return nil }

      let prefix = "\(bucket)/"
      let normalizedPath = trimmed.hasPrefix(prefix) ? String(trimmed.dropFirst(prefix.count)) : trimmed

      do {
        return try storage.from(bucket).getPublicURL(path: normalizedPath)
      } catch {
        NSLog("❌ SupabaseClient: Failed to generate public URL for path %@: %@", normalizedPath, error.localizedDescription)
        return nil
      }
    }
}
