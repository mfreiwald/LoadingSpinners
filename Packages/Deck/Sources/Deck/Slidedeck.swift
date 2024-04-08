@_exported import DeckUI
import SwiftUI

public let presenter = Presenter(deck: deck, showCamera: false)
#if canImport(AppKit)
public let notes = PresenterNotes()
#endif
let deck = Deck(title: "Loading Spinners") {
}
