import SwiftUI
import Core
import DeckUI

let IntroBlurHashSlide = Slide {
    Title("BlurHash")

    RawView {
        IntroBlurHashExamples()
            .overlay(alignment: .topTrailing) {
                Link("https://blurha.sh/", destination: URL(string: "https://blurha.sh/")!)
                    .offset(y: -100)
                    .font(.largeTitle)
            }
    }
}

private struct IntroBlurHashExamples: View {
    var images: [ImageModel] = Array(ImageProvider().load().prefix(3)).map { ImageModel($0) }

    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 40, verticalSpacing: 40) {
            ForEach(images) {
                IntroBlurHashExample(data: $0)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct IntroBlurHashExample: View {
    let data: ImageModel

    var body: some View {
        GridRow(alignment: .center) {
            ImageViewContainer(data: data) {
                EmptyView()
            }
            .environment(\.apiClient, APIClientLive(withDelay: false))

            Text(data.imageHash!)
                .font(.title)
                .lineLimit(1)
                .gridCellColumns(2)

            Image(blurHash: data.imageHash!)?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(.rect(cornerRadius: 12))
        }
    }
}

struct BlurHashExample: View {
    let data: ImageModel = .mock
    var body: some View {
        HStack {
            Code(.swift) {
"""





AsyncImage(url: data.url) { image in
    image
        .resizable()
} placeholder: {
    Image(blurHash: data.blurHash)
        .resizable()
}
"""
            }.asView

            ImageViewHash(data: .mock)
        }
        .padding()
    }
}

#Preview {
    BlurHashExample()
}
