import SwiftUI

struct OpenAppView {
    var openAppView: (AppView) -> Void
    func callAsFunction(_ appView: AppView) {
        openAppView(appView)
    }
}

extension OpenAppView: EnvironmentKey {
    static var defaultValue: OpenAppView = .init(openAppView: {_ in })
}

extension EnvironmentValues {
    var openAppView: OpenAppView {
        get { self[OpenAppView.self] }
        set { self[OpenAppView.self] = newValue }
    }
}

struct AppViewNavigationLink<Label: View>: View {
    let appView: AppView
    @ViewBuilder var label: () -> Label

    @Environment(\.openAppView) private var openAppView

    var body: some View {
        Button(action: { openAppView(appView) }, label: label)
    }
}

extension AppViewNavigationLink where Label == Text {
    init(title: String, appView: AppView) {
        self.init(appView: appView, label: {Text(title)})
    }
}
