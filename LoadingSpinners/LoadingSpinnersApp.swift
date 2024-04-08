//
//  LoadingSpinnersApp.swift
//  LoadingSpinners
//
//  Created by Michael on 14.03.24.
//

import SwiftUI
import DeckUI
import Core

@main
struct LoadingSpinnersApp: App {
    var body: some Scene {
        WindowGroup {
            AppContent()
                .statusBar(hidden: true)
        }
    }
}

private struct AppContent: View {
    @State var currentSlide: Slides = Slides.allCases.first!
    @State var appView: AppView? = nil

    var body: some View {
        TabView(selection: $currentSlide) {
            ForEach(Slides.allCases) { slide in
                slide
                    .tag(slide)
            }
        }
        .environment(\.openAppView, .init(openAppView: {
            self.appView = $0
        }))
        .background(Theme.standard.background)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .fullScreenCover(item: $appView) { appView in
            appView
                .environment(\.colorScheme, .dark)
                .onTapGesture(count: 3, perform: {
                    self.appView = nil
                })
        }
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    AppContent()
}
