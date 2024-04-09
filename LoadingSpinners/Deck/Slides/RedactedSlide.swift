import SwiftUI
import DeckUI

struct RedactedSlide: View {
    var body: some View {
        VStack {
            Code(.swift, highlightLines: [(1...1), (12...14)]) {
"""
   var body: some View {
        Row(model: isLoading ? .placeholder : .mock)
    }

    @ViewBuilder
    func Row(model: RowModel) -> some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .font(.headline)
            Text(model.description)
                .font(.subheadline)
        }
        .redacted(reason:
            model.isPlaceholder ? .placeholder : []
        )
    }
"""
            }
            .asView

            RedactedSlideExample()
                .padding(.bottom, 20)
        }
        .padding()
    }
}

private struct RedactedSlideExample: View {
    @State private var isLoading = true

    var body: some View {
        HStack(alignment: .center, spacing: 30) {
            CardRow {
                Row(model: .placeholder)
            }
            .frame(height: 150)

            VStack(spacing: 20) {
                Image(systemName: "arrowshape.right.fill")
                    .scaleEffect(2.0)

                LoadingView()
            }

            CardRow {
                Row(model: .mock)
            }
            .frame(height: 150)

        }
    }
}

struct RedactedSlideExtendedExample: View {
    @Binding var placeholders: Int
    @State private var isLoading = true
    @State private var loadedData: [RowModel] = []

    private var data: [RowModel] {
        isLoading ? RowModel.placeholders(placeholders) : loadedData
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(data) { model in
                    Button {} label: {
                        CardRow {
                            Row(model: model)
                        }
                        .tint(.primary)
                    }
                    .buttonStyle(.plain)
                    .disabled(model.isPlaceholder)
                    .redacted(reason: model.isPlaceholder ? .placeholder : [])
                }
            }
        }
        .refreshable { await fetchData() }
        .task { await fetchData() }
    }

    @MainActor
    private func fetchData() async {
        isLoading = true
        let loadedData = await backendCall()

        withAnimation {
            self.loadedData = loadedData
            isLoading = false
        }

        placeholders = loadedData.count
    }

    private func backendCall() async -> [RowModel] {
        await Task.detached {
            sleep(3)
            return RowModel.mocks.shuffled()
        }.value
    }
}
struct Row: View {
    let model: RowModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .font(.headline)
            Text(model.description)
                .font(.subheadline)
        }
        .redacted(reason: model.isPlaceholder ? .placeholder : [])
    }
}

struct CardRow<Content: View>: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.background)
            .frame(maxWidth: 500, minHeight: 100, alignment: .leading)
            .clipShape(.rect(cornerRadius: 12))
            .overlay(alignment: .leading) {
                content()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .dynamicTypeSize(.accessibility1)
    }
}

struct CardRedactedExample: View {
    var body: some View {
        CardRow {
            Row(model: .placeholder)
        }
        .frame(height: 150)
    }
}

struct RowModel: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
}

extension RowModel {
    static var mock: Self {
        Self(
            id: UUID().uuidString,
            title: "AI generates high-quality images",
            description: "Stable Diffusion and DALL-E-3"
        )
    }

    static var mocks: [Self] {[
        Self(
            id: UUID().uuidString,
            title: "Generative AI Revolutionizes Content Creation",
            description: "The latest advances in generative AI are transforming the landscape of digital content creation, enabling creators to produce more with less effort."
        ),
        Self(
            id: UUID().uuidString,
            title: "AI-generated Artwork Wins Prestigious Award",
            description: "For the first time in history, a piece of art created by an AI program has won a top prize at an internationally renowned art competition."
        ),
        Self(
            id: UUID().uuidString,
            title: "Generative AI Models Now Able to Write Original Music",
            description: "New AI models can now compose original music pieces, challenging the boundaries between technology and human creativity."
        ),
        Self(
            id: UUID().uuidString,
            title: "Film Industry Embraces AI for Scriptwriting and Animation",
            description: "The film industry is increasingly turning to generative AI for scriptwriting assistance and to create lifelike animations at a fraction of the usual cost."
        ),
        Self(
            id: UUID().uuidString,
            title: "Breakthrough in AI-generated Educational Resources",
            description: "Educators celebrate the arrival of AI tools capable of generating customized and interactive educational materials for students."
        ),
        Self(
            id: UUID().uuidString,
            title: "New Generative AI Startup Secures Record Funding",
            description: "A startup specializing in generative AI technology has secured the largest ever venture capital funding round in the sector."
        ),
        Self(
            id: UUID().uuidString,
            title: "Generative AI's Role in Accelerating Drug Discovery",
            description: "Pharmaceutical companies are leveraging generative AI to simulate and predict the efficacy of drug compounds, speeding up the discovery process."
        ),
        Self(
            id: UUID().uuidString,
            title: "Fashion Designers Turn to AI for Next-Gen Apparel",
            description: "In a bold move, fashion designers are now using generative AI to create innovative and sustainable clothing designs."
        ),
        Self(
            id: UUID().uuidString,
            title: "AI-generated Personalized Learning Plans Revolutionize Education",
            description: "Generative AI is personalizing education by creating unique learning plans tailored to individual student needs and learning styles."
        ),
        Self(
            id: UUID().uuidString,
            title: "Ethical Debate Intensifies Over Generative AI in Journalism",
            description: "As generative AI becomes more prevalent in journalism, ethical debates emerge regarding the use of AI-generated content in news media."
        )
    ]}

    static var placeholder: Self {
        Self(
            id: Self.placeholderID(),
            title: "placeholder-copy-title",
            description: "placeholder-copy-description"
        )
    }

    static func placeholders(_ count: Int) -> [Self] {
        (0..<count).map { _ in Self.placeholder }
    }
}

extension Identifiable where ID == String {
    private static var placeholderIDPrefix: String { "__PLACEHOLDER-" }

    static func placeholderID() -> String { Self.placeholderIDPrefix + UUID().uuidString }

    var isPlaceholder: Bool {
        id.hasPrefix(Self.placeholderIDPrefix)
    }
}
