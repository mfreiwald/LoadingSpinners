import SwiftUI
import DeckUI

struct DeferredNavigation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            AppViewNavigationLink(title: "➡️ Intentional delay", appView: .navigationDelay)
                .apply(\.body)

            AppViewNavigationLink(title: "➡️ Custom transition", appView: .navigationCustom)
                .apply(\.body)

            Code(.swift) {
"""
struct DeferredNavigation<Label: View, Value: Identifiable & Hashable> {
  var body: some View {
    Button {
      loadTask = Task {
        do {
          let updatedValue = await performAction(value)
          push(updatedValue)
        } catch {
          push(value)
        }

      }
      timeoutTask = Task {
        try? await Task.sleep(for: .milliseconds(150))
        push(value)
      }
    } label: {
      label()
    }
  }
}
"""
            }.asView
        }
        .padding()
    }
}

#Preview {
    SlidesPreview(slides: [.deferredNavigation])
}
