import SwiftUI
import DeckUI

struct DeferredLoadingIntro: View {
    @State var tapped = false
    var body: some View {
        ZStack {
            if tapped {
                DeferredLoadingModifierIntro()
            } else {
                LoadingModifierIntro()
            }
        }
        .contentShape(.rect)
        .onTapGesture {
            withAnimation {
                tapped = true
            }
        }
        .onLongPressGesture {
            withAnimation {
                tapped = false
            }
        }
        .hasMore(!tapped)
    }
}

private struct LoadingModifierIntro: View {
    var body: some View {
        VStack(alignment: .leading) {
            Title("Loading Modifier").asView
                .padding()

            HStack(alignment: .center) {
                LikeButtonLoading()
                    .buttonStuff(2.0)
                    .scaleEffect(3.0)
                    .frame(width: 320)

                ButtonLoadingCode()
            }
        }
    }
}

private struct DeferredLoadingModifierIntro: View {
    var body: some View {
        VStack(alignment: .leading) {
            Title("Deferred Loading Modifier").asView
                .padding()

            HStack(alignment: .center) {
                VStack {
                    Text("150 ms")
                    LikeButtonDeferred(duration: .milliseconds(200))
                        .buttonStuff(0.15)
                        .frame(width: 320)
                        .padding(.bottom, 20)

                    Text("950 ms")
                    LikeButtonDeferred(duration: .milliseconds(200))
                        .buttonStuff(0.95)
                        .frame(width: 320)
                }
                .scaleEffect(3.0)

                ButtonLoadingDeferredCode()
            }
        }
    }
}

private struct ButtonLoadingCode: View {
    var body: some View {
        VStack {
            Code(.swift) {
"""
struct LoadingIndicatorModifier: ViewModifier {
  var isLoading = false

  func body(content: Content) -> some View {
    content
      .opacity(isLoading ? 0 : 1)
      .overlay {
        if isLoading {
          LoadingView()
        }
      }
      .animation(.easeInOut, value: isLoading)
  }
}

extension View {
  func loadingIndicator(_ isLoading: Bool) -> some View {
    modifier(LoadingIndicatorModifier(isLoading: isLoading))
  }
}

"""
            }.asView
        }
    }
}

private struct ButtonLoadingDeferredCode: View {
    var body: some View {
        VStack {
            Code(.swift, highlightLines: [(2...2), (28...34)]) {
"""
struct DeferredLoadingIndicatorModifier: ViewModifier {
  var isLoading = false
  var deferredDuration: Duration = .milliseconds(200)

  @State private var visible = false
  @State private var task: Task<Void, Never>?

  func body(content: Content) -> some View {
    content
      .opacity(visible ? 0 : 1)
      .overlay {
        if visible { LoadingView() }
      }
      .onChange(of: isLoading, initial: true) { _, newValue in
        isLoadingChanged(newValue: newValue)
      }
      .animation(.easeInOut, value: visible)
  }

  private func isLoadingChanged(newValue isLoading: Bool) {
    task?.cancel()

    guard isLoading else {
      visible = false
      return
    }

    task = Task {
      try? await Task.sleep(for: deferredDuration)

      guard !Task.isCancelled else { return }

      if isLoading {
        visible = true
      }
    }
  }
}
"""
            }.asView
        }
    }
}

#Preview {
    SlidesPreview(slides: [.deferredLoadingIntro])
}
