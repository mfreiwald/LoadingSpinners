import Foundation
import UnifiedBlurHash
import SwiftUI

public struct ImageData: Codable, Identifiable, Hashable, Equatable, Sendable {
    public var id: String
    public var title: String
    public var description: String
    public var prompt: String
    public var url: String
    public var blurHash: String?

    public init(id: String, title: String, description: String, prompt: String, url: String, blurHash: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.prompt = prompt
        self.url = url
        self.blurHash = blurHash
    }

    public var jsonFileName: String {
        imageName + ".json"
    }

    public var imageFileName: String {
        imageName + ".png"
    }

    public var imageName: String {
        id
    }
}

extension ImageData {
    public var image: Image? {
        Image(imageName, bundle: .module)
    }

    public var blurHashImage: Image? {
        guard let blurHash else { return nil }
        return Image(blurHash: blurHash)
    }
}

