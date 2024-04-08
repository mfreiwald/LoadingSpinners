import SwiftUI
import DeckUI

extension Theme: EnvironmentKey {
    public static var defaultValue: Theme = .standard
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[Theme.self] }
        set { self[Theme.self] = newValue }
    }
}

struct ForegroundStyleViewModifier: ViewModifier {
    let foreground: KeyPath<Theme, Foreground>
    @Environment(\.theme) private var theme

    func body(content: Content) -> some View {
        content
            .foregroundColor(theme[keyPath: foreground].color)
            .font(theme[keyPath: foreground].font)
    }
}
extension View {
    func apply(_ foreground: KeyPath<Theme, Foreground>) -> some View {
        modifier(ForegroundStyleViewModifier(foreground: foreground))
    }
}
