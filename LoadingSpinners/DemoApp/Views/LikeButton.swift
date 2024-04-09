import SwiftUI
import Core
import Pow

struct LikeButtonDisabled: View {
    @State private var liked = false
    @State private var loading = false

    var body: some View {
        LikeButtonContainer(liked: $liked, loading: $loading) {
            Label("Like", systemImage: liked ? "heart.fill" : "heart")
                .labelStyle(.iconOnly)
                .controlSize(.regular)
        }
        .disabled(loading)
    }
}

struct LikeButtonBlocked: View {
    var loadingChanged: (Bool) -> ()
    @State private var liked = false
    @State private var loading = false

    var body: some View {
        LikeButtonContainer(liked: $liked, loading: $loading) {
            Label("Like", systemImage: liked ? "heart.fill" : "heart")
                .labelStyle(.iconOnly)
                .controlSize(.regular)
        }
        .onChange(of: loading, initial: false) { _, isLoading in
            loadingChanged(isLoading)
        }
    }
}

struct LikeButtonLoading: View {
    @State private var liked = false
    @State private var loading = false

    var body: some View {
        LikeButtonContainer(liked: $liked, loading: $loading) {
            Label("Like", systemImage: liked ? "heart.fill" : "heart")
                .labelStyle(.iconOnly)
                .loadingIndicator(loading)
                .controlSize(.regular)
        }
        .disabled(loading)
    }
}

struct LikeButtonDeferred: View {
    var duration: Duration = .milliseconds(200)
    @State private var liked = false
    @State private var loading = false

    var body: some View {
        LikeButtonContainer(liked: $liked, loading: $loading) {
            Label("Like", systemImage: liked ? "heart.fill" : "heart")
                .labelStyle(.iconOnly)
                .deferredLoadingIndicator(loading, deferredDuration: duration)
                .controlSize(.regular)
        }
//        .disabled(loading)
    }
}

struct LikeButtonAnimation: View {
    @State private var liked = false
    @State private var loading = false

    @State private var likedAnimation = false

    @Environment(\.accessibilityReduceMotion) var reduzeMotion

    var body: some View {
        LikeButtonContainer(liked: $liked, loading: $loading) {
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
        .onChange(of: loading) { oldValue, newValue in
            if newValue {
                likedAnimation = !liked
            }
        }
    }
}

struct LikeButtonContainer<Label: View>: View {
    @Binding var liked: Bool
    @Binding var loading: Bool
    @ViewBuilder var label: () -> Label

    @Environment(\.apiClient) private var apiClient
    @Environment(\.likeDelay) private var likeDelay
    @Environment(\.redactionReasons) private var redactionReasons

    var body: some View {
        Button {
            Task { await like() }
        } label: {
            if redactionReasons == .placeholder {
                Text("")
            } else {
                label()
            }
        }
        .allowsHitTesting(!loading)
    }

    @MainActor
    func like() async {
        loading = true
        await apiClient.like(milliseconds: likeDelay)
        liked.toggle()
        loading = false
    }
}

#Preview {
    VStack {
        LikeButtonDisabled()
        LikeButtonLoading()
        LikeButtonAnimation()
    }
    .environment(\.likeDelay, 2000)
    .frame(width: 500)
    .buttonStyle(.bordered)
    .tint(.orange)
    .scaleEffect(2)
}

private enum LikeDelayKey: EnvironmentKey {
    static var defaultValue: Int? = nil
}

extension EnvironmentValues {
    var likeDelay: Int? {
        get { self[LikeDelayKey.self] }
        set { self[LikeDelayKey.self] = newValue }
    }
}
