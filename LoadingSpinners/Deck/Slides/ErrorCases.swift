import SwiftUI
import DeckUI
import ButtonKit

struct ErrorCases: View {
    @State var showContent = false

    var body: some View {
        VStack {
            HStack {
                Text("⚠️ Errors")
                    .apply(\.title)

                 (showContent ? Text("") : Text("?"))
                    .apply(\.title)
                if showContent {
                    Spacer()
                }
            }

            if showContent {
                contentView
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(.rect)
        .onTapGesture {
            withAnimation {
                showContent = true
            }
        }
        .hasMore(!showContent)
    }

    @ViewBuilder
    private var contentView: some View {
        Spacer()

        ButtonAnimation()
            .buttonStuff(1.0)
            .scaleEffect(3.0)
            .throwableButtonStyle(.none)
            .padding(.bottom, 120)

        ButtonAnimation()
            .buttonStuff(1.0)
            .scaleEffect(3.0)
            .throwableButtonStyle(.shake)

        Spacer()
    }
}

#Preview {
    SlidesPreview(slides: [.errorCases])
}

private struct ButtonAnimation: View {
    @State private var liked = false
    @State private var loading = false

    @State private var likedAnimation = false

    var body: some View {
        ButtonContainer(liked: $liked, loading: $loading) {
            if likedAnimation {
                Label("Like", systemImage: "heart.fill")
                    .labelStyle(.iconOnly)
                    .transition(.movingParts.pop(.orange))
                    .deferredLoadingIndicator(loading, deferredDuration: .milliseconds(1200))
                    .controlSize(.regular)
            } else {
                Label("Like", systemImage: "heart")
                    .deferredLoadingIndicator(loading, deferredDuration: .milliseconds(200))
                    .labelStyle(.iconOnly)
                    .transition(.identity)
                    .controlSize(.regular)
            }
        }
//        .disabled(loading)
        .onChange(of: loading) { oldValue, newValue in
            print("loading \(loading) => liked: \(liked) ")
            if newValue {
                likedAnimation = !liked
            } else {
                likedAnimation = liked
            }
        }
    }
}

private struct ButtonContainer<Label: View>: View {
    @Binding var liked: Bool
    @Binding var loading: Bool
    @ViewBuilder var label: () -> Label
    @State var error: Error?

    @Environment(\.apiClient) private var apiClient
    @Environment(\.likeDelay) private var likeDelay
    @Environment(\.redactionReasons) private var redactionReasons

    var body: some View {
        AsyncButton {
            try await like()
        } label: {
            if redactionReasons == .placeholder {
                Text("")
            } else {
                label()
            }
        }
        .asyncButtonStyle(.none)
        .allowsHitTesting(!loading)
    }

    @MainActor
    func like() async throws {
        defer { loading = false }
        loading = true
        await apiClient.like(milliseconds: likeDelay)
        throw NSError()
    }
}
