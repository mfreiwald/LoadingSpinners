import SwiftUI
import DeckUI

enum AppView: Identifiable {
    case appDemonstration
    case appOverviewRedacted
    case appOverviewHashed
    case appOverviewAnimated
    case navigationDelay
    case navigationCustom

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

            case .appOverviewAnimated:
                OverviewAnimated()

            case .navigationDelay:
                OverviewNavigation()

            case .navigationCustom:
                OverviewNavigationCustom()
            }
        }
        .tint(.orange)
    }
}

#Preview {
    AppView.appOverviewAnimated
}
