import SwiftUI

struct LoadingIndicatorModifier: ViewModifier {
    var isLoading = false
    var hideContent = true

    @State private var visible = false
    @State private var task: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .opacity(isLoading && hideContent ? 0 : 1)
            .overlay {
                if isLoading { LoadingView(size: .regular).frame(maxWidth: .infinity, alignment: .center) }
            }
            .animation(.easeInOut, value: isLoading)
    }
}

extension View {
    func loadingIndicator(_ isLoading: Bool, hideContent: Bool = true) -> some View {
        modifier(LoadingIndicatorModifier(isLoading: isLoading, hideContent: hideContent))
    }
}
