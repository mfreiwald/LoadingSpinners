//
//  ImagesCollectionView.swift
//  DemoApp
//
//  Created by Michael on 18.03.24.
//

import SwiftUI

let cellSize: CGFloat = 250

struct ImagesCollectionView<ImageView: View, RemixButton: View, LikeButton: View>: View {
    let images: [ImageModel]
    @ViewBuilder var imageView: (ImageModel) -> ImageView
    @ViewBuilder var remixButton: () -> RemixButton
    @ViewBuilder var likeButton: () -> LikeButton

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    .init(.adaptive(minimum: cellSize, maximum: cellSize), spacing: nil, alignment: .center)
                ],
                spacing: 32
            ) {
                ForEach(images) {
                    ImageRowView(data: $0) {
                        imageView($0)
                    } remixButton: {
                        remixButton()
                    } likeButton: {
                        likeButton()
                    }
                    .environment(\.likeDelay, sleepForId($0.id))
                    .padding(.horizontal, 16)
                }
            }
        }
        .contentMargins(16, for: .scrollContent)
    }
}

#Preview {
    ImagesCollectionView(images: .mocks) {
        ImageViewLoading(data: $0)
    } remixButton: {
        RemixButton()
    } likeButton: {
        LikeButtonLoading()
    }
    .environment(\.apiClient, APIClientLive(withDelay: false))
    .tint(.orange)
}

private func sleepForId(_ id: String) -> Int? {
    switch id {
    case "C0AD758F-43FE-45E2-8937-764BCDEADEF1":
        return 140
    case "DF067A02-CED2-48BE-8141-F77D6BF75762":
        return 250
    case "6E829F33-6F6E-49FD-AA45-6217DD4AA5D8":
        return 500
    case "54419295-E446-46EF-A4E1-4E48B550F1BC":
        return 1000
    default:
        return nil
    }
}
