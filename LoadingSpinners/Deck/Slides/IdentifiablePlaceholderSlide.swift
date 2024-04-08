import SwiftUI
import DeckUI

let IdentifablePlaceholderSlide = Slide {
    Title("Identifiable Placeholder")

    Code(.swift) {
"""
extension Identifiable where ID == String {
    private static var placeholderIDPrefix: String {
        "__PLACEHOLDER-"
    }

    static func placeholderID() -> String {
        Self.placeholderIDPrefix + UUID().uuidString
    }

    var isPlaceholder: Bool {
        id.hasPrefix(Self.placeholderIDPrefix)
    }
}
"""
    }
}

let MockAndPlaceholderSlide = Slide {
    Title("Placeholder Example")

    Code(.swift, highlightLines: [(3...3), (11...11)]) {
"""
extension RowModel {
    static var mock: Self {
        Self(
            id: UUID().uuidString,
            title: "AI generates high-quality images",
            description: "Stable Diffusion and DALL-E-3"
        )
    }

    static var placeholder: Self {
        Self(
            id: Self.placeholderID(),
            title: "placeholder-copy-title",
            description: "placeholder-copy-description"
        )
    }
}
"""
    }
}

struct MockAndPlaceholderInActionSlide: View {
    @State var showHighlights = false
    @State var placeholders = 4
    var body: some View {
        Grid {
            GridRow {
                RedactedSlideExtendedExample(placeholders: $placeholders)
                    .gridCellColumns(3)

                    Code(.swift, highlightLines: showHighlights ? [(4...10), (19...19)] : []) {
"""
struct RootView: View {
  @State var isLoading = true
  @State var loadedData: [RowModel]

  var data: [RowModel] {
    if isLoading {
      RowModel.placeholders
    } else {
      loadedData
    }
  }

  var body: some View {
    ForEach(data) { model in
      Button {} label: {
        CardRow {
          Row(model: model)
        }
        .buttonStyle(.plain)
        .disabled(model.isPlaceholder)
      }
    }
    .refreshable { await fetchData() }
    .task { await fetchData() }
  }
}
"""
                    }
                    .asView

                .gridCellColumns(4)
                .onTapGesture {
                    withAnimation {
                        showHighlights.toggle()
                    }
                }
                .onLongPressGesture {
                    placeholders = 4
                }
            }
        }
        .padding()
    }
}

#Preview {
    SlidesPreview(slides: [
//        .identifablePlaceholder,
//        .mockAndPlaceholder,
        .redacted,
        .mockAndPlaceholderExample,
        .appWithRedacted,
    ])
}

public extension Binding {

    static func convert<TInt, TFloat>(from intBinding: Binding<TInt>) -> Binding<TFloat>
    where TInt:   BinaryInteger,
          TFloat: BinaryFloatingPoint{

        Binding<TFloat> (
            get: { TFloat(intBinding.wrappedValue) },
            set: { intBinding.wrappedValue = TInt($0) }
        )
    }

    static func convert<TFloat, TInt>(from floatBinding: Binding<TFloat>) -> Binding<TInt>
    where TFloat: BinaryFloatingPoint,
          TInt:   BinaryInteger {

        Binding<TInt> (
            get: { TInt(floatBinding.wrappedValue) },
            set: { floatBinding.wrappedValue = TFloat($0) }
        )
    }
}
