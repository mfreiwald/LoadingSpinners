import SwiftUI

struct ThankYouSlide: View {
    @State private var status = false

    let activeTint = Color.purple
    let inactiveTint = Color.purple.opacity(0.8)

    var body: some View {
        VStack {
            Spacer()

            HStack(spacing: 40) {
                Text("Thank you")
                    .font(.system(size: 70, weight: .semibold, design: .rounded))

                Image(systemName: "heart.fill")
                    .foregroundColor(status ? .pink : .pink.opacity(0.8))
                    .scaleEffect(status ? 1.0 : 0.8)
                    .font(.system(size: 50))
                    .particleEffect(
                        systemImage: "heart.fill",
                        font: .system(size: 50),
                        status: status,
                        activeTint: activeTint,
                        inActiveTint: inactiveTint
                    )
                    .particleEffectStyle(.circle(80...120))
                    .frame(width: 200)
            }
            .padding(.top, 160)

            Spacer()

            VStack {
                Text("Inspired by")
                    .italic()
                    .font(.system(size: 33))

                LazyVGrid(columns: [
                    .init(.fixed(250)),
                    .init(.fixed(250)),
                    .init(.fixed(250)),
                    .init(.fixed(250)),
                    .init(.fixed(250))
                ]){
                    inspired("👨‍💻 Gui Rambo", link: "https://rambo.codes/") {
                        AsyncImage(url: URL(string: "https://rambo.codes/assets/img/2018header_v2.jpg")) {
                            $0.image?
                                .resizable()
                        }
                        .scaleEffect(0.8)
                    }

                    inspired("🔘 ButtonKit", link: "https://github.com/Dean151/ButtonKit") {
                        VStack {
                            Spacer()
                            Button("ButtonKit") {}
                                .buttonStyle(.bordered)
                                .tint(.accentColor)
                                .font(.system(size: 40))
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }

                    inspired("🥰 Pow", link: "https://github.com/EmergeTools/Pow") {
                        VStack {
                            Spacer()
                            Button("Pow") {}
                                .buttonStyle(.bordered)
                                .tint(.accentColor)
                                .font(.system(size: 40))
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }

                    inspired("🌫️ BlurHash", link: "https://blurha.sh/") {
                        Image(blurHash: ImageModel.mock.imageHash!)!
                            .resizable()
                            .scaleEffect(0.8)
                    }

                    inspired("✨ DeckUI", link: "https://github.com/joshdholtz/DeckUI") {
                        VStack {
                            Spacer()
                            Text("✨ DeckUI")
                            Spacer()
                        }
                        .font(.system(size: 40))
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                    }
                }
                .tint(.white)
                .font(.system(size: 20))
            }
            .foregroundColor(.white)
            .scaleEffect(0.7)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .overlay(alignment: .topLeading) {
            VStack {
                Image("repo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)

                Text("Slides")
                    .font(.title.italic())
            }
            .padding(.leading, 50)
            .padding(.top, 30)
            .scaleEffect(0.8)

        }
        .overlay(alignment: .topTrailing) {
            VStack {
                Image("mastodon-qr")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)

                Text("Mastodon")
                    .font(.title.italic())
            }
            .padding(.trailing, 50)
            .padding(.top, 30)
            .scaleEffect(0.8)
        }
        .task {
            repeat {
                try? await Task.sleep(for: .milliseconds(800))
                withAnimation {
                    status.toggle()
                }
            } while !Task.isCancelled
        }
    }

    @ViewBuilder
    private func inspired<ImageView: View>(_ title: String, link: String, image: @escaping () -> ImageView) -> some View {
        Inspire(title, link, image)
            .frame(height: 200)
            .font(.largeTitle)
            .fontWeight(.semibold)
    }
}

struct Inspire<Content: View>: View {
    let size: CGFloat = 75
    let title: String
    let link: String
    let content: Content

    init(_ title: String, _ link: String, _ content: @escaping () -> Content) {
        self.title = title
        self.link = link
        self.content = content()
    }

    var body: some View {
        VStack {
//            content
//                .frame(width: size, height: size)

            Link(title, destination: URL(string: link)!)
        }
        .transaction { transaction in
            transaction.animation = nil
        }
    }
}

enum ParticleEffectStyle {
    case move(Direction)
    case circle(ClosedRange<Int>)

    enum Direction {
        case top
        case bottom
        case leading
        case trailing
    }
}

extension ParticleEffectStyle: EnvironmentKey {
    static var defaultValue: ParticleEffectStyle = .circle(15...30)
}

@available(iOS 13, tvOS 13, *)
extension EnvironmentValues {
    var particleEffectStyle: ParticleEffectStyle {
        get { self[ParticleEffectStyle.self] }
        set { self[ParticleEffectStyle.self] = newValue }
    }
}

@available(iOS 15, tvOS 15, *)
extension View {
    func particleEffect(systemImage: String, font: Font, status: Bool, activeTint: Color, inActiveTint: Color) -> some View {
        modifier(ParticleModifier(systemImage: systemImage, font: font, status: status, activeTint: activeTint, inactiveTint: inActiveTint))
    }

    func particleEffectStyle(_ style: ParticleEffectStyle) -> some View {
        environment(\.particleEffectStyle, style)
    }
}

@available(iOS 15, tvOS 15, *)
private struct Particle: Identifiable {
    var id: UUID = .init()
    var randomX: CGFloat = 0
    var randomY: CGFloat = 0
    var scale: CGFloat = 1

    var opacity: CGFloat = 0

    mutating func reset() {
        randomX = 0
        randomY = 0
        scale = 1
        opacity = 0
    }
}

@available(iOS 15, tvOS 15, *)
struct ParticleModifier: ViewModifier {
    var systemImage: String
    var font: Font
    var status: Bool
    var activeTint: Color
    var inactiveTint: Color

    @State private var particles: [Particle] = []
    @Environment(\.particleEffectStyle) private var style: ParticleEffectStyle

    private var numberParticles: Int {
        switch style {
        case .move:
            return 16
        case .circle:
            return 10
        }
    }

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                particleOverlay
                    .onAppear {
                        if particles.isEmpty {
                            for _ in 0 ..< numberParticles {
                                let particle = Particle()
                                particles.append(particle)
                            }
                        }
                    }
                    .onChange(of: status) { newValue in
                        if newValue {
                            showAndHideParticles()
                        } else {
                            for index in particles.indices {
                                particles[index].reset()
                            }
                        }
                    }
            }
    }

    @ViewBuilder private var particleOverlay: some View {
        ZStack {
            ForEach(particles) { particle in
                Image(systemName: systemImage)
                    .font(font)
                    .foregroundColor(status ? activeTint : inactiveTint)
                    .scaleEffect(particle.scale)
                    .offset(x: particle.randomX, y: particle.randomY)
                    .opacity(particle.opacity)
                    .opacity(status ? 1 : 0)
                    .animation(.none, value: status)
            }
        }
    }

    private func showAndHideParticles() {
        for index in particles.indices {
            let total: CGFloat = CGFloat(particles.count)
            let progress: CGFloat = CGFloat(index) / total

            let point: CGPoint
            switch style {
            case let .circle(radius):
                point = circlePosition(progress, radius: radius)
            case let .move(direction):
                point = movePosition(progress, direction: direction)
            }

            let randomScale: CGFloat = .random(in: 0.35 ... 1)

            particles[index].opacity = 1
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                particles[index].randomX = point.x
                particles[index].randomY = point.y
            }

            withAnimation(.easeInOut(duration: 0.3)) {
                particles[index].scale = randomScale
            }

            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)
                .delay(0.25 + (Double(index) * 0.005))) {
                    particles[index].scale = 0.001
                }
        }
    }

    private func circlePosition(_ progress: CGFloat, radius radiusRange: ClosedRange<Int>) -> CGPoint {
        let angle = Angle(degrees: progress * 360).radians
        let radius: Int = .random(in: radiusRange)
        let posX = CGFloat(radius) * cos(angle)
        let posY = CGFloat(radius) * sin(angle)
        return .init(x: posX, y: posY)
    }

    private func movePosition(_ progress: CGFloat, direction: ParticleEffectStyle.Direction) -> CGPoint {
        let maxX: CGFloat = (progress > 0.5) ? 100 : -100
        let maxY: CGFloat = 60

        let randomX: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxX)
        let randomY: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxY) + 35

        let extraRandomX: CGFloat = (progress < 0.5 ? .random(in: 0 ... 10) : .random(in: -10 ... 0))
        let extraRandomY: CGFloat = .random(in: 0 ... 30)

        let posX = randomX + extraRandomX
        let posY = -randomY - extraRandomY

        let directionX: CGFloat
        let directionY: CGFloat

        switch direction {
        case .top:
            directionX = posX
            directionY = posY
        case .bottom:
            directionX = posX
            directionY = -posY
        case .leading:
            directionX = posY
            directionY = posX
        case .trailing:
            directionX = -posY
            directionY = posX
        }

        return .init(x: directionX, y: directionY)
    }
}

#Preview {
    SlidesPreview(slides: [.thankyou])
}
