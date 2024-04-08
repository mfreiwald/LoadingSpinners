import SwiftUI
@_exported import UnifiedBlurHash

public struct BlurImage: View {
    let hash: String
    
    public init(hash: String) {
        self.hash = hash
    }

    public var body: some View {
        Image(blurHash: hash)
    }
}
