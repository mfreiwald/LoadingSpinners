import SwiftUI

struct SummarySlide: View {
    var body: some View {
        SlideView()
            .padding()
    }
}

private struct SlideView: View {
    let bigFont: Font = .system(size: 100, weight: .semibold, design: .rounded)
    let smallFont: Font = .system(size: 25, weight: .semibold, design: .rounded)
    let middleFont: Font = .system(size: 55, weight: .semibold, design: .rounded)

    @State private var show1 = false
    @State private var show2 = false
    @State private var show3 = false
    @State private var show4 = false
    @State private var show5 = true
    @State private var show6 = false
    @State private var show7 = false
    @State private var show8 = false
    @State private var show9 = false

    var body: some View {
        VStack {
            Grid {
                GridRow {
                    box(show1) {
                        CardRedactedExample()
//                        highlight("Up to", "5x", end: "faster than UIKit", hex: ["#2193b0", "#6dd5ed"])
//                            .redacted(reason: .placeholder)
                    }
                    box(show2) {
                        Text("Use animations")
                            .multilineTextAlignment(.center)
                            .font(middleFont)
                            .foregroundStyle(LinearGradient(colors: [Color(hex: "#00F260"), Color(hex: "#0575E6")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    }
                    box(show3) {
                        Image(blurHash: ImageModel.mock.imageHash!)!
                            .resizable()
                            .scaleEffect(0.8)
                    }
                }
                GridRow {
                    box(show4) {
                        Text("Use transition time")
                            .multilineTextAlignment(.center)
                            .font(middleFont)
                            .foregroundStyle(LinearGradient(colors: [Color(hex: "#659999"), Color(hex: "#f4791f")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    }
                    box(show5) {
                        VStack {
                            LoadingView(size: .large)
                                .scaleEffect(2.0)
                        }
                    }
                    box(show6) {
                        highlight("Revert state on", "Errors", end: "", hex: ["#544a7d", "#ffd452"])
                    }
                }
                GridRow {
                    box(show7) {
                        highlight("Up to", "200 ms", end: "delayed indicator", hex: ["#ED213A", "#93291E"])
                    }
                    box(show8) {
                        Text("Make your app fast")
                            .multilineTextAlignment(.center)
                            .font(middleFont)
                            .foregroundStyle(LinearGradient(colors: [Color(hex: "#7F7FD5"), Color(hex: "#86A8E7"), Color(hex: "#91EAE4")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    }
                    box(show9) {

                        highlight("Keep interaction while", "loading", end: "to cancel", hex: ["#fdbb2d", "#b21f1f"])
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            showNext += 1
            if showNext < showOrder.count {
                withAnimation {
                    showOrder[showNext].wrappedValue = true
                }
            }
        }
        .task {
            showOrder = [
                $show5,
                $show1,
                $show3,
                $show7,
                $show2,
                $show6,
                $show9,
                $show4,
                $show8
            ]
//            try? await Task.sleep(for: .seconds(5))
//            show1 = true
//            try? await Task.sleep(for: .seconds(1))
//            show3 = true
//            try? await Task.sleep(for: .seconds(1))
//            show7 = true
//            try? await Task.sleep(for: .seconds(1))
//            show2 = true
//            try? await Task.sleep(for: .seconds(1))
//            show6 = true
//            try? await Task.sleep(for: .seconds(0.5))
//            show9 = true
//            try? await Task.sleep(for: .seconds(1))
//            show4 = true
//            try? await Task.sleep(for: .seconds(1))
//            show8 = true
        }
    }

    @State private var showNext = 0
    @State private var showOrder: [Binding<Bool>] = []

    @ViewBuilder
    func highlight(_ first: String, _ highlight: String, end: String, hex: [String]) -> some View {
        VStack {
            Text(first)
                .font(smallFont)
            Text(highlight)
                .font(bigFont)
                .foregroundStyle(LinearGradient(colors: hex.map { Color(hex: $0) }, startPoint: .topLeading, endPoint: .bottomTrailing))
            Text(end)
                .font(smallFont)
        }
    }

    @ViewBuilder
    func box<Content: View>(_ isOn: Bool, @ViewBuilder content: () -> Content) -> some View {
        VStack {
            if isOn {
                content()
                    .transition(.scale.animation(.spring()))
            } else {
                Text("")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    SlidesPreview(slides: [.summary])
}
