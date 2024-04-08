import Foundation
import UnifiedBlurHash
import AsyncAlgorithms

public final class ImageProvider: Sendable {
    public init() {}

    public nonisolated func load() -> [ImageData] {
        guard let configURL = Bundle.module.url(forResource: "combined", withExtension: "json") else { return [] }
        guard let data = try? Data(contentsOf: configURL) else { return [] }
        return (try? JSONDecoder().decode([ImageData].self, from: data)) ?? []
    }
}
