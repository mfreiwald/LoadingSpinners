import SwiftUI
import DeckUI

struct DeferredWithAnimation: View {
    enum ViewState {
        case noAnimation1Second
        case withAnimationButton
        case animation1Second
        case animationDeferred
        case reduceMotion
    }

    @State private var viewState: ViewState = .noAnimation1Second
    @Namespace private var namespace

    // If the call always takes around 1 second
    var body: some View {
        VStack(alignment: .leading) {
            Title(viewState == .reduceMotion ? "♿️ Accessbility in Mind" : "What about longer tasks?").asView
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            switch viewState {
            case .noAnimation1Second, .withAnimationButton:
                noAnimation(withAnimation: viewState == .withAnimationButton)
            case .animation1Second, .animationDeferred:
                animationShort(long: viewState == .animationDeferred)
            case .reduceMotion:
                Code(.swift, highlightLines: [(2...2), (4...10), (16...16)]) {
"""
struct LikeButton: View {
  @State private var likedAnimation = false
  @Environment(\\.accessibilityReduceMotion) var reduceMotion

  var transition: AnyTransition {
      if reduceMotion {
        .movingParts.pop(.orange)
      } else {
        .identity
      }
  }

  var body: some View {
    LikeButtonContainer {
      if likedAnimation {
        Label("Like", systemImage: "heart.fill")
          .transition(transition)
          .deferredLoadingIndicator(
            loading,
            deferredDuration: .milliseconds(1200)
          )
      } else {
        Label("Like", systemImage: "heart")
          .transition(.identity)
          .deferredLoadingIndicator(
            loading,
            deferredDuration: .milliseconds(200)
          )
      }
    }
}

"""
                }.asView
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(.rect)
        .onTapGesture {
            withAnimation {
                switch viewState {
                case .noAnimation1Second:
                    viewState = .withAnimationButton
                case .withAnimationButton:
                    viewState = .animation1Second
                case .animation1Second:
                    viewState = .animationDeferred
                case .animationDeferred:
                    viewState = .reduceMotion
                case .reduceMotion:
                    ()
                }
            }
        }
        .padding()
        .hasMore(viewState != .reduceMotion)
    }

    @ViewBuilder
    private func noAnimation(withAnimation: Bool) -> some View {
        HStack(alignment: .center) {
            Grid(alignment: .center) {
                GridRow(alignment: .center) {
                    Text("950 ms")
                        .apply(\.body)
                        .matchedGeometryEffect(id: "950t", in: namespace)

                    LikeButtonDeferred()
                        .buttonStuff(0.95)
                        .frame(width: 320, height: 200)
                        .scaleEffect(3.0)           
                        .matchedGeometryEffect(id: "950d", in: namespace)

                    LikeButtonAnimation()
                        .buttonStuff(0.95)
                        .frame(width: 320, height: 200)
                        .scaleEffect(3.0)
                        .matchedGeometryEffect(id: "950a", in: namespace)
                        .opacity(withAnimation ? 1 : 0)
                }

                    GridRow {
                        Text("")
                        Text("")
                        if viewState == .withAnimationButton {
                            Text("Add some animation")
                        } else {
                            Text("Add some animation").hidden()
                        }
                    }
                    .apply(\.body)

            }
            .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private func animationShort(long: Bool) -> some View {
        HStack(alignment: .center) {
            Grid(alignment: .center) {
                GridRow {
                    Text("150 ms")
                        .apply(\.body)

                    LikeButtonAnimation()
                        .buttonStuff(0.15)
                        .frame(width: 320, height: 200)
                        .scaleEffect(3.0)

                }

                GridRow(alignment: .center) {
                    Text("950 ms")
                        .apply(\.body)
                        .matchedGeometryEffect(id: "950t", in: namespace)

                    LikeButtonAnimation()
                        .buttonStuff(0.95)
                        .frame(width: 320, height: 200)
                        .scaleEffect(3.0)
                        .matchedGeometryEffect(id: "950a", in: namespace)

                }

                GridRow {
                    Text("2000 ms")
                        .apply(\.body)

                    LikeButtonAnimation()
                        .buttonStuff(2.0)
                        .frame(width: 320, height: 200)
                        .scaleEffect(3.0)
                }
                .opacity(long ? 1 : 0)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

private struct CodeView: View {
    var body: some View {
        Code(.swift) {
"""
"""
        }.asView
    }
}

#Preview {
    SlidesPreview(slides: [.deferredWithAnimation])
}
