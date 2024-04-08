import SwiftUI
import DeckUI

enum AppView: Identifiable {
    case appDemonstration
    case appOverviewRedacted
    case appOverviewHashed

    var id: Self {
        self
    }
}

extension AppView: View {
    var body: some View {
        ZStack {
            Theme.defaultValue.background

            switch self {
            case .appDemonstration:
                OverviewLoading()

            case .appOverviewRedacted:
                OverviewRedacted()

            case .appOverviewHashed:
                OverviewHashed()
            }
        }
        .tint(.orange)
    }
}

#Preview {
    AppView.appDemonstration
}
