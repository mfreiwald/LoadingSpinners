import SwiftUI
import DeckUI

enum AppView: Identifiable {
    case appDemonstrationBlocked
    case appDemonstrationLoading
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
            case .appDemonstrationBlocked:
                OverviewLoadingBlocked()
                
            case .appDemonstrationLoading:
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
