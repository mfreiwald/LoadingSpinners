import SwiftUI

struct LoadingView: View {
    enum Size {
        case regular
        case large
    }

    var size: Size = .regular

    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(size == .large ? 2 : 1)
    }
}
