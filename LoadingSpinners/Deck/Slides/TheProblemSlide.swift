import SwiftUI
import DeckUI
import Core
import ActivityIndicatorView

struct TheProblemSlide: View {
    @State private var showLoading = true
    @State private var showMore = false
    @State private var appearCount = 0
    @Namespace private var namespace

    var body: some View {
        if showLoading {
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray.opacity(0.4))
                .frame(width: 200, height: 200)
                .overlay {
                    LoadingView(size: .large)
                }
                .matchedGeometryEffect(id: "loading", in: namespace)
                .onTapGesture {
                    withAnimation {
                        showLoading = false
                    }
                }
        } else {
            ContentView()
                .onDisappear {
                    showLoading = true
                }
        }
    }

    @ViewBuilder
    private func ContentView() -> some View {
        VStack {
            HStack {
                Title("The Problem").asView
                Spacer()
            }

            RoundedRectangle(cornerRadius: 12)
                .fill(.gray.opacity(0.4))
                .frame(width: 200, height: 200)
                .overlay {
                    LoadingView(size: .large)
                }
                .matchedGeometryEffect(id: "loading", in: namespace)

            if showMore {
                Spacer()

                Loadings()
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(.rect)
        .onTapGesture {
            withAnimation {
                showMore = true
            }
        }
    }
}

private struct Loadings: View {
    @State var appearCount: Int = 0

    var body: some View {
        HStack {
            Spacer()

            indi(.equalizer(count: 3))
                .opacity(appearCount > 0 ? 1 : 0)

            Spacer()

            indi(.scalingDots(count: 3, inset: 2))
                .opacity(appearCount > 1 ? 1 : 0)


            Spacer()

            indi(.gradient([.white, .red], lineWidth: 4))
                .opacity(appearCount > 2 ? 1 : 0)

            Spacer()
        }
        .task {
            try? await Task.sleep(for: .seconds(1))
            withAnimation { appearCount += 1}
            try? await Task.sleep(for: .seconds(1))
            withAnimation { appearCount += 1}
            try? await Task.sleep(for: .seconds(1))
            withAnimation { appearCount += 1}
        }
    }

    @ViewBuilder
    private func indi(_ type: ActivityIndicatorView.IndicatorType) -> some View {
        ActivityIndicatorView(isVisible: .constant(true),
                              type: type)
        .frame(width: 100.0, height: 100.0)
    }
}

#Preview {
    SlidesPreview(slides: [.theProblem])
}
