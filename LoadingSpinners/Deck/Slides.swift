import SwiftUI
import DeckUI

enum Slides: String, CaseIterable, Identifiable {
    case title
    case whoAmI
    case theProblem
    case aboutThisTalk
    case exampleAppBlocked
    case exampleAppLoading
    case placeholderIntro
    case mockAndPlaceholder
    case identifablePlaceholder
    case redacted
    case mockAndPlaceholderExample
    case appWithRedacted
    case introBlurHash
    case blurHashExample
    case appWithBlurHash
    case likeExample
    case buttonLoading
    case deferredLoadingIntro
    case deferredWithAnimation
    case errorCases
    case appWithAnimation
    case deferredNavigation
    case appStore
    case summary
    case thankyou

    var id: Self {
        self
    }
}

extension Slides: View {
    var body: some View {
        switch self {
        case .title: TitleSlide()
        case .whoAmI: WhoAmISlide.asView
        case .theProblem: TheProblemSlide()
        case .aboutThisTalk: AboutThisTask()
        case .exampleAppBlocked: AppViewSlide(appView: .appDemonstrationBlocked)
        case .exampleAppLoading: AppViewSlide(appView: .appDemonstrationLoading)
        case .placeholderIntro: PlaceholderIntro()
        case .mockAndPlaceholder: MockAndPlaceholderSlide.asView
        case .identifablePlaceholder: IdentifablePlaceholderSlide.asView
        case .redacted: RedactedSlide()
        case .mockAndPlaceholderExample: MockAndPlaceholderInActionSlide()
        case .appWithRedacted: AppViewSlide(appView: .appOverviewRedacted)
        case .introBlurHash: IntroBlurHashSlide.asView
        case .blurHashExample: BlurHashExample()
        case .appWithBlurHash: AppViewSlide(appView: .appOverviewHashed)
        case .likeExample: SlideLikeExample()
        case .buttonLoading: ButtonLoading()
        case .deferredLoadingIntro: DeferredLoadingIntro()
        case .deferredWithAnimation: DeferredWithAnimation()
        case .errorCases: ErrorCases()
        case .appWithAnimation: AppViewSlide(appView: .appOverviewAnimated)
        case .deferredNavigation: DeferredNavigation()
        case .appStore: AppStore()
        case .summary: SummarySlide()
        case .thankyou: ThankYouSlide()
        }
    }
}

struct SlidesPreview: View {
    let slides: [Slides]

    var body: some View {
        TabView {
            ForEach(slides) {
                $0
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.standard.background)
    }
}

#Preview {
    SlidesPreview(slides: Slides.allCases)
}
