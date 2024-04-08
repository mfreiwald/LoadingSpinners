//
//  ImageView.swift
//  DemoApp
//
//  Created by Michael on 18.03.24.
//

import SwiftUI

struct ImageViewLoading: View {
    let data: ImageModel

    var body: some View {
        ImageViewContainer(data: data) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.gray.opacity(0.4))
                .frame(width: 70, height: 70)
                .overlay {
                    LoadingView(size: .large)
                }
        }
    }
}

struct ImageViewHash: View {
    let data: ImageModel

    var body: some View {
        ImageViewContainer(data: data) {
            Image(blurHash: data.imageHash!)?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(.rect(cornerRadius: 12))
        }
    }
}

struct ImageViewRedacted: View {
    let data: ImageModel

    var body: some View {
        ImageViewContainer(data: data) {
            Image(blurHash: data.imageHash!)?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(.rect(cornerRadius: 12))
                .redacted(reason: .placeholder)
        }
    }
}

struct ImageViewContainer<Placeholder: View>: View {
    let data: ImageModel
    @ViewBuilder var placeholder: () -> Placeholder

    @State private var image: Image?
    @Environment(\.apiClient) private var apiClient

    var body: some View {
        ZStack {
            if let image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 12))
            } else {
                placeholder()
            }
        }
        .animation(.easeInOut(duration: 1), value: image)
        .task {
            image = await apiClient.fetchImage(id: data.id)
        }
    }
}

#Preview {
    VStack {
        ImageViewLoading(data: .mock)
            .frame(width: 200, height: 200)
        ImageViewHash(data: .mock)
            .frame(width: 200, height: 200)
        ImageViewRedacted(data: .mock)
            .frame(width: 200, height: 200)
    }
    .environment(\.apiClient, APIClientLive(withDelay: true))
    .padding()
}
