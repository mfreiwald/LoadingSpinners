import SwiftUI
import DeckUI

enum Slides: CaseIterable, Identifiable {
    case title
    case whoAmI
    case theProblem
    case aboutThisTalk
    case exampleApp
    case identifablePlaceholder
    case mockAndPlaceholder
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
    case longLoadingButton
    case summary
    case thankyou
//    case buttonLoadingDeferred

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
        case .aboutThisTalk: AboutThisTask.asView
        case .exampleApp: AppViewSlide(appView: .appDemonstration)
        case .identifablePlaceholder: IdentifablePlaceholderSlide.asView
        case .mockAndPlaceholder: MockAndPlaceholderSlide.asView
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
        case .longLoadingButton: LongLoadingButton()
        case .summary: SummarySlide()
        case .thankyou: ThankYouSlide()
//        case .buttonLoadingDeferred: ButtonLoadingDeferred()
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
