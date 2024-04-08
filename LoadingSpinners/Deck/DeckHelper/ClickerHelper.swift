import SwiftUI

struct ClickerHelper: ViewModifier {
    var showMore = false
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottomTrailing) {
                if showMore {
                    Text("🔄")
                } else {
                    Text("➡️")
                }
            }
    }
}

extension View {
    func hasMore(_ hasMore: Bool) -> some View {
        modifier(ClickerHelper(showMore: hasMore))
    }
}
