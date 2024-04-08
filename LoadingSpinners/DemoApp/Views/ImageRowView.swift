//
//  ImageRowView.swift
//  DemoApp
//
//  Created by Michael on 18.03.24.
//

import SwiftUI

struct ImageRowView<ImageView: View, LikeButton: View>: View {
    let data: ImageModel
    @ViewBuilder var imageView: (ImageModel) -> ImageView
    @ViewBuilder var likeButton: () -> LikeButton

    @Environment(\.redactionReasons) private var redactionReasons

    var body: some View {
        VStack {
            imageView(data)
                .frame(width: cellSize - 32, height: cellSize - 32)

            HStack {
                Button {

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
                }

                likeButton()
            }
            .controlSize(.extraLarge)
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 12))
            .frame(width: cellSize - 32)
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            ImageRowView(data: .mock) {
                ImageViewLoading(data: $0)
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
