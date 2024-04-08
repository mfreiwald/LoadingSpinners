import SwiftUI
import DeckUI

struct AboutThisTask: View {
    @State var started = false
    @State var result = false
    var body: some View {
        VStack {
            HStack {
                (
                    Text("This talk is ") + (started ? Text("not").underline() + Text(" ") : Text("")) + Text("about")
                ).apply(\.title)
                Spacer()
            }


            if started {
                HStack {
                    Bullets(style: .custom("⚠️")) {
                        Words("How to cache data")
                        Words("Increase your app performance")
                    }
                    .asView

                    Spacer()
                }
                .padding(.top, 40)
            }

            if result {
                Text("Instead")
                    .apply(\.subtitle)
                    .padding(.vertical, 40)

                HStack {
                    Bullets(style: .custom("✅")) {
                        Words("Your app is performance optimized")
                        Words("Fast servers / CDN")
                    }
                    .asView
                    Spacer()
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(.rect)
        .onTapGesture {
            withAnimation {
                if started {
                    result = true
                } else {
                    started = true
                }
            }
        }
        .padding()
        .hasMore(!started || !result)
    }
}

#Preview {
    AboutThisTask()
}
