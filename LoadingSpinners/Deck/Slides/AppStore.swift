import SwiftUI
import DeckUI

struct AppStore: View {
    var body: some View {
        VStack {
            Image("appstore")
                .resizable()
                .frame(width: 200, height: 200)
                .onTapGesture {
                    if let url = URL(string: "itms-apps://") {
                        UIApplication.shared.open(url)
                    }
                }
        }
        .padding()
    }
}

#Preview {
    SlidesPreview(slides: [.appStore])
}
