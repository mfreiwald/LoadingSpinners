//
//  ImageRowView.swift
//  DemoApp
//
//  Created by Michael on 18.03.24.
//

import SwiftUI

struct ImageRowView<ImageView: View, RemixButton: View, LikeButton: View>: View {
    let data: ImageModel
    @ViewBuilder var imageView: (ImageModel) -> ImageView
    @ViewBuilder var remixButton: () -> RemixButton
    @ViewBuilder var likeButton: () -> LikeButton

    @Environment(\.redactionReasons) private var redactionReasons

    var body: some View {
        VStack {
            imageView(data)
                .frame(width: cellSize - 32, height: cellSize - 32)

            HStack {
                remixButton()

                likeButton()
            }
            .controlSize(.extraLarge)
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 12))
            .frame(width: cellSize - 32)
        }
    }
}

struct RemixButtonBlocked: View {
    var loadingChanged: (Bool) -> Void
    @State private var runRemix = false

    var body: some View {
        Button {
            runRemix = true
        } label: {
            Group {
                Label("Remix", systemImage: "repeat")
            }
            .lineLimit(1)
            .frame(maxWidth: .infinity)
            .labelStyle(.titleAndIcon)
            .controlSize(.regular)
        }
        .task(id: runRemix) {
            guard runRemix else { return }
            loadingChanged(true)
            try? await Task.sleep(for: .seconds(8))
            runRemix = false
            loadingChanged(false)
        }
    }
}
struct RemixButton: View {
    @Environment(\.redactionReasons) private var redactionReasons

    @State private var runRemix = false

    var body: some View {
        Button {
            runRemix = true
        } label: {
            Group {
                if redactionReasons == .placeholder {
                    Text("")
                } else {
                    Label("Remix", systemImage: "repeat")
                }
            }
            .lineLimit(1)
            .frame(maxWidth: .infinity)
            .labelStyle(.titleAndIcon)
            .loadingIndicator(runRemix)
            .controlSize(.regular)
        }
        .task(id: runRemix) {
            guard runRemix else { return }
            try? await Task.sleep(for: .seconds(8))
            runRemix = false
        }
    }
}

import ButtonKit

struct RemixButtonProgress: View {
    @Environment(\.redactionReasons) private var redactionReasons

    @State private var downloaded = false

    var body: some View {
        AsyncButton(progress: .download) { progress in
            guard !downloaded else {
                downloaded = false
                return
            }
            // Indeterminate loading
            try? await Task.sleep(for: .seconds(2))
            progress.bytesToDownload = 100 // Fake
            // Download started!
            for _ in 1...100 {
                try? await Task.sleep(for: .seconds(0.05))
                progress.bytesDownloaded += 1
            }
            // Installation
            try? await Task.sleep(for: .seconds(0.5))
            if !Task.isCancelled {
                downloaded = true
            }
            // Reset
            try? await Task.sleep(for: .seconds(0.5))
            if !Task.isCancelled {
                downloaded = false
            }
        } label: {
            Group {
                if redactionReasons == .placeholder {
                    Text("")
                } else {
                    Label("Remix", systemImage: "repeat")
                }
            }
            .lineLimit(1)
            .frame(maxWidth: .infinity)
            .labelStyle(.titleAndIcon)
            .controlSize(.regular)
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            ImageRowView(data: .mock) {
                ImageViewLoading(data: $0)
            } remixButton: {
                RemixButton()
            } likeButton: {
                LikeButtonLoading()
            }
        }
        .environment(\.likeDelay, 500)
        .frame(maxWidth: .infinity)
    }
    .environment(\.apiClient, APIClientLive(withDelay: false))
    .padding()
    .tint(.orange)
}
