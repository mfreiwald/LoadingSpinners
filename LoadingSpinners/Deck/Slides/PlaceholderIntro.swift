import SwiftUI

struct PlaceholderIntro: View {
    @State var count = 0

    @State var loadingIndicator = true
//    @State var placeholder = true

    var body: some View {
        VStack {
            CardRow {
                Row(model: .mock)
            }
            .frame(height: 150)

            if count > 0 {
                CardRow {
                    Row(model: .mock)
                        .loadingIndicator(loadingIndicator)
                }
                .frame(height: 150)
                .task(id: loadingIndicator) {
                    try? await Task.sleep(for: .seconds(3))
                    withAnimation {
                        loadingIndicator.toggle()
                    }
                }
            }

            if count > 1 {
                CardRow {
                    Row(model: loadingIndicator ? .placeholder : .mock)
                }
                .frame(height: 150)
//                .task(id: placeholder) {
//                    try? await Task.sleep(for: .seconds(3))
//                    placeholder.toggle()
//                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(.rect)
        .onTapGesture {
            withAnimation {
                count += 1
            }
        }
        .padding()
        .hasMore(count < 2)
    }
}

#Preview {
    SlidesPreview(slides: [.placeholderIntro])
}
