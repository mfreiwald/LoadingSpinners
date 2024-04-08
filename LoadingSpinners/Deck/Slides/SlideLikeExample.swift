import SwiftUI
import DeckUI

let exampleScale = 2.0

struct SlideLikeExample: View {
    private let delayValues: [Double] = [0.15, 0.25, 0.5, 1.0, 2.5]
    @State private var delayIndex: Double = 3
    private var delay: Double {
        delayValues[Int(delayIndex)]
    }

    @Environment(\.theme) private var theme
    @Namespace private var namespace

    @State var showButtonOnly = false

    @State var scaleButton = false

    var body: some View {
        Grid {
            GridRow {
                if showButtonOnly {
                    buttonOnly
                        .scaleEffect(scaleButton ? 1.5 : 1.0)
                        .task {
                            try? await Task.sleep(for: .seconds(1))
                            withAnimation {
                                scaleButton = true
                            }
                        }
                        .onDisappear {
                            scaleButton = false
                        }
                } else {
                    fullCard
                }

                VStack {
                    Text("Duration: \(delay.formatted(.number)) second\(delayIndex == 3 ? "" : "s")")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Slider(value: $delayIndex, in: (0...4), step: 1) {
                        Text(delay.formatted())
                    }
                }
                .padding(.horizontal, 40)
                .font(theme.body.font)
                .foregroundColor(theme.body.color)
                .opacity(showButtonOnly ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .environment(\.apiClient, APIClientLive(withDelay: false))
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.default.speed(0.5)) {
                showButtonOnly = true
            }
        }
        .onLongPressGesture {
            withAnimation {
                showButtonOnly = false
            }
        }
        .hasMore(!showButtonOnly)
    }

    @ViewBuilder
    var buttonOnly: some View {
        LikeButtonLoading()
            .matchedGeometryEffect(id: "button", in: namespace)
            .environment(\.likeDelay, Int(delay * 1000))
            .tint(.orange)
            .scaleEffect(exampleScale)
            .controlSize(.extraLarge)
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 12))
    }

    @ViewBuilder
    var fullCard: some View {
        ImageRowView(data: .mock) {
            ImageViewLoading(data: $0)
        } remixButton: {
            RemixButton()
        } likeButton: {
            LikeButtonLoading()
                .matchedGeometryEffect(id: "button", in: namespace)
        }
        .environment(\.likeDelay, Int(delay * 1000))
        .tint(.orange)
        .scaleEffect(exampleScale)
    }
}

#Preview {
    SlidesPreview(slides: [.likeExample])
}
