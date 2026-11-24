import Foundation
import KromaCore

/// Vytváří položky médií z externích URL při importu do projektu.
public protocol MediaImporter: Sendable {
    func makeMediaItems(for urls: [URL]) -> [MediaItem]
}

public struct DefaultMediaImporter: MediaImporter {
    public init() {}

    public func makeMediaItems(for urls: [URL]) -> [MediaItem] {
        urls.compactMap { url in
            guard let format = SupportedFormat.format(for: url) else { return nil }
            return MediaItem(url: url, kind: format.kind)
        }
    }
}
