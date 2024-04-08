import Foundation
import Core
import SwiftUI

protocol APIClient: Sendable {
    func images() async -> [ImageModel]
    func image(id: String) async -> ImageModel?
    func fetchImage(id: String) async -> Image?
    func like(milliseconds: Int?) async -> Void
}

final class APIClientLive: APIClient, Sendable {
    let provider = ImageProvider()

    let withDelay: Bool

    init(withDelay: Bool = true) {
        self.withDelay = withDelay
    }

    func images() async -> [ImageModel] {
        if withDelay {
            sleep(3)
        }
        return provider.load().map(ImageModel.init(_:))
    }

    func image(id: String) async -> ImageModel? {
        if withDelay {
            sleep(3)
        }
        return provider.load().first(where: {$0.id == id}).map(ImageModel.init(_:))
    }

    func cached(id: String) async -> Image? {
        return provider.load().first(where: {$0.id == id})?.blurHashImage
    }

    func fetchImage(id: String) async -> Image? {
        if withDelay {
            let milliseconds = (1000...4000).randomElement() ?? 2000
            let duration = Duration.milliseconds(milliseconds)
            try? await Task.sleep(for: duration)
//            sleep( (1...4).randomElement() ?? 2 )
        }
        return provider.load().first(where: {$0.id == id})?.image
    }

    func like(milliseconds: Int?) async {
        let wait: Int
        if let milliseconds {
            wait = milliseconds
        } else {
            wait = (100...1500).randomElement() ?? 250
        }
        let duration = Duration.milliseconds(wait)
        try? await Task.sleep(for: duration)
    }
}

enum APIClientKey: EnvironmentKey {
    static nonisolated let defaultValue: APIClient = APIClientLive()
}

extension EnvironmentValues {
    var apiClient: APIClient {
        get { self[APIClientKey.self] }
        set { self[APIClientKey.self] = newValue }
    }
}

extension APIClient {
    static var noDelay: APIClient { APIClientLive(withDelay: false) }
}


struct ImageModel: Identifiable, Hashable {
    var id: String
    var title: String
    var description: String
    var prompt: String
    var imageHash: String?
    var url: String
}

extension ImageModel {
    init(_ data: ImageData) {
        self.init(
            id: data.id,
            title: data.title,
            description: data.description,
            prompt: data.prompt,
            imageHash: data.blurHash,
            url: data.url
        )
    }
}

extension ImageModel {
    static let mock: Self = ImageModel(
        id: "28CBF122-36E1-4CA5-A02C-C4AAF24C1B58",
        title: "Berlin in the 1980s",
        description: "No description",
        prompt: "Berlin in the 1980s",
        imageHash: "LFEM5mE-D+.S*JS2IV%f6RxWr;R%",
        url: "https://dalleprodsec.blob.core.windows.net/private/images/0ac4667c-84bd-4df6-8a0a-fdc27e229747/generated_00.png?se=2024-03-19T13%3A27%3A35Z&sig=WV58QCMN69P6JXyST2i18G2dDqeMYcAYH1jS11IxSRk%3D&ske=2024-03-18T23%3A30%3A19Z&skoid=e52d5ed7-0657-4f62-bc12-7e5dbb260a96&sks=b&skt=2024-03-11T23%3A30%3A19Z&sktid=33e01921-4d64-4f8c-a055-5bdaffd5e33d&skv=2020-10-02&sp=r&spr=https&sr=b&sv=2020-10-02"
    )
}

extension Collection where Element == ImageModel {
    static var mocks: [Element] { ImageProvider().load().map(ImageModel.init(_:)) }
}
