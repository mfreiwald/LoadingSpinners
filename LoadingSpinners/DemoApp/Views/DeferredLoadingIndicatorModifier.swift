import SwiftUI

struct DeferredLoadingIndicatorModifier: ViewModifier {
    var isLoading = false
    var deferredDuration: Duration?

    @State private var visible = false
    @State private var task: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .opacity(visible ? 0 : 1)
            .overlay {
                if visible { LoadingView(size: .regular) }
            }
            .onChange(of: isLoading, initial: true) { oldValue, newValue in
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
            try? await Task.sleep(for: deferredDuration ?? .milliseconds(200))

            guard !Task.isCancelled else { return }

            if isLoading {
                visible = true
            }
        }
    }
}

extension View {
    func deferredLoadingIndicator(_ isLoading: Bool, deferredDuration: Duration? = nil) -> some View {
        modifier(DeferredLoadingIndicatorModifier(isLoading: isLoading, deferredDuration: deferredDuration))
    }
}
