import SwiftUI

struct ClickerHelper: ViewModifier {
    var showMore = false
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottomTrailing) {
                Group {
                    if showMore {
                        Text("⚠️")
                            .grayscale(1)
                            .opacity(0.3)
                    } else {
                        Text("🙂")
                            .grayscale(1)
                            .opacity(0.8)
                    }
                }
                .grayscale(1)
                .opacity(0.3)
                .padding(.trailing, 10)
                .scaleEffect(0.7)
            }
    }
}

extension View {
    func hasMore(_ hasMore: Bool) -> some View {
        modifier(ClickerHelper(showMore: hasMore))
    }
}

#Preview {
    Color.clear
        .hasMore(true)
}
