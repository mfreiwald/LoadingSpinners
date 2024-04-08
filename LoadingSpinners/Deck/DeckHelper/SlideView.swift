import DeckUI
import SwiftUI

extension Slide {
    @ViewBuilder
    var asView: some View {
        SlideView(slide: self)
    }

    private struct SlideView: View {
        let slide: Slide

        @Environment(\.theme) private var theme

        var body: some View {
            slide.buildView(theme: theme)
        }
    }
}

extension ContentItem {
    @ViewBuilder
    var asView: some View {
        ContentItemView(content: self)
    }
}

private struct ContentItemView: View {
    let content: ContentItem

    @Environment(\.theme) private var theme

    var body: some View {
        content.buildView(theme: theme)
    }
}
