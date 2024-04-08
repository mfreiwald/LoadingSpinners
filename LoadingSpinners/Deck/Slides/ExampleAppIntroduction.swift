import DeckUI
import SwiftUI

struct ExampleAppIntroduction: View {
    var body: some View {
        AppViewSlide(appView: .appDemonstration)
    }
}

#Preview {
    ExampleAppIntroduction()
}

struct AppViewSlide: View {
    let appView: AppView
    var showTitle = true

    var body: some View {
        VStack {
            AppViewNavigationLink(appView: appView) {
                if let image = UIImage(named: AppIconProvider.appIcon()) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                        .clipShape(.rect(cornerRadius: 24))
                }
            }

            if showTitle {
                Text("PicturAI")
            }
        }
        .apply(\.body)
    }
}

enum AppIconProvider {
    static func appIcon(in bundle: Bundle = .main) -> String {
        guard let icons = bundle.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.last else {
            fatalError("Could not find icons in bundle")
        }
        return iconFileName
    }
}
