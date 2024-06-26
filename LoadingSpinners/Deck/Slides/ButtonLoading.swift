import SwiftUI
import DeckUI

struct ButtonLoading: View {
    private let delayValues: [Double] = [0.15, 0.25, 0.5, 1.0, 2.5]
    @State private var delayIndex: Double = 3
    private var delay: Double {
        delayValues[Int(delayIndex)]
    }

    @Environment(\.theme) private var theme

    var body: some View {
        Grid {
            GridRow {
                VStack(spacing: 10) {
                    LikeButtonDisabled()
                        .buttonStuff(delay)

                    LikeButtonLoading()
                        .buttonStuff(delay)
                }
                .scaleEffect(3.0)

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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .environment(\.apiClient, APIClientLive(withDelay: false))
        .contentShape(.rect)
    }
}

extension View {
    func buttonStuff(_ delay: Double) -> some View {
        environment(\.likeDelay, Int(delay * 1000))
        .tint(.orange)
        .controlSize(.extraLarge)
        .buttonStyle(.bordered)
        .buttonBorderShape(.roundedRectangle(radius: 12))
    }
}

#Preview {
    SlidesPreview(slides: [.buttonLoading])
}
