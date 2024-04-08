import SwiftUI
import DeckUI

let WhoAmISlide = Slide {
    let hSpacing: CGFloat = 20
    Title("About me")
    Columns {
        Column {
            RawView {
                WhoAmI()
            }
        }
        Column {

        }
    }
}

private struct RotatingSwift: View {
    @State var animate = false
    var body: some View {
        Text("🥰")
            .scaleEffect(animate ? 1.2 : 0.8)
            .onAppear {
                withAnimation(.easeInOut.speed(0.6).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
    }
}

struct WhoAmI: View {
    @Environment(\.theme) private var theme
    let hSpacing: CGFloat = 20

    var randDelay: Duration {
        .milliseconds( (1000...4000).randomElement() ?? 1000 )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            HStack(spacing: hSpacing) {
                Text("👨‍💻")

                Text("Michael Freiwald")
            }
            .loadingDelayAppeared(.seconds(2))

            HStack(spacing: hSpacing) {
                Text("👨‍💻")
                    .hidden()
                    .overlay {
                        Image("netlight")
                            .resizable()
                            .scaledToFit()
                    }

                Text("IT-Consultant @ \(Text("Netlight").italic().foregroundColor(.purple))")
            }
            .loadingDelayAppeared(.seconds(1))

            HStack(spacing: hSpacing) {
                Text("👨‍💻")
                    .hidden()
                    .overlay {
                        Image("swift")
                            .resizable()
                            .scaledToFit()
                    }

                HStack(spacing: 4) {
                    Text("In love with ")
                    Text("Swift")
                        .italic()
                        .foregroundStyle(Color.orange.gradient)
                    Text(" & ")
                    Text("SwiftUI")
                        .italic()
                        .foregroundStyle(Color.blue.gradient)
                }
            }
            .loadingDelayAppeared(.seconds(3))

            HStack(spacing: hSpacing) {
                RotatingSwift()

                Text("Enjoy making fluid apps")
            }
            .loadingDelayAppeared(.seconds(4))

        }
        .apply(\.body)
    }
}

struct WhoAmI_Previews: PreviewProvider {
    static var previews: some View {
        WhoAmISlide.buildView(theme: .dark)
    }
}

extension View {
    @ViewBuilder
    func loadingDelayAppeared(_ delay: Duration) -> some View {
        delayAppeared(delay) {
            LoadingView()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
