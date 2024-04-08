import DeckUI
import SwiftUI

struct TitleSlide: View {
    enum ViewState {
        case meetup
        case loading
        case title
    }

    @State private var viewState: ViewState = .meetup
    @Namespace private var namespace
    @Environment(\.theme) private var theme

    var body: some View {
        switch viewState {
        case .meetup:
            meetupDeck
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(.rect)
                .onTapGesture {
                    viewState = .loading
                }
        case .loading:
            LoadingView(size: .large)
                .scaleEffect(2.0)
                .matchedGeometryEffect(id: "loading", in: namespace)
                .task {
                    try? await Task.sleep(for: .seconds(3))
                    withAnimation {
                        viewState = .title
                    }
                }
        case .title:
            HStack {
                LoadingView(size: .large)
                                .offset(x: -40)
                                .scaleEffect(2.0)
                                .matchedGeometryEffect(id: "loading", in: namespace)

                    titleDeck
                    .delayAppeared(.milliseconds(200)) { EmptyView() }
            }
        }
    }

    @ViewBuilder
    private var meetupDeck: some View {
        VStack {
            Title("Swift Meetup Munich #34", subtitle: "Netlight Edition")
                .asView
        }
    }

    @ViewBuilder
    private var titleDeck: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Loading Spinners")
                .font(theme.title.font)
                .foregroundColor(theme.title.color)

            Text("and how to avoid them")
                .font(theme.subtitle.font)
                .foregroundColor(theme.subtitle.color)

        }
        .padding(.bottom, 20)
    }
}

#Preview {
    TitleSlide()
}

private struct DelayedAppear<Placeholder: View>: ViewModifier {
    let delay: Duration
    var animation: Animation = .default
    @ViewBuilder var placeholder: () -> Placeholder
    @State private var appeared = false

    func body(content: Content) -> some View {
        ZStack {
            if appeared {
                content
            } else {
                content.hidden()
                    .overlay {
                        placeholder()
                    }
            }
        }
        .task {
            try? await Task.sleep(for: delay)
            withAnimation(animation) {
                appeared = true
            }
        }
    }
}

extension View {
    func delayAppeared<Placeholder: View>(
        _ delay: Duration,
        animation: Animation = .default,
        _ placeholder: @escaping () -> Placeholder
    ) -> some View {
        modifier(
            DelayedAppear(
                delay: delay,
                animation: animation,
                placeholder: placeholder
            )
        )
    }
}
