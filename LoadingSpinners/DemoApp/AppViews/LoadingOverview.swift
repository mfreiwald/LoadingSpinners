import SwiftUI

struct OverviewLoading: View {
    var body: some View {
        OverviewContainer { data, imageView, likeButton in
            ImagesCollectionView(images: data, imageView: imageView, likeButton: likeButton)
                .overlay {
                    if data.isEmpty {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray.opacity(0.4))
                            .frame(width: 200, height: 200)
                            .overlay {
                                LoadingView(size: .large)
                            }
                    }
                }
        } imageView: {
            ImageViewLoading(data: $0)
        } likeButton: {
            LikeButtonLoading()
        }
    }
}

struct OverviewRedacted: View {
    var body: some View {
        OverviewContainer { data, imageView, likeButton in
            ZStack {
                if data.isEmpty {
                    ImagesCollectionView(images: Array([ImageModel].mocks.prefix(6)), imageView: imageView, likeButton: likeButton)
                        .redacted(reason: .placeholder)
                        .allowsHitTesting(false)
                } else {
                    ImagesCollectionView(images: data, imageView: imageView, likeButton: likeButton)
                }
            }
            .animation(.easeInOut, value: data.isEmpty)
        } imageView: {
            ImageViewRedacted(data: $0)
        } likeButton: {
            LikeButtonLoading()
        }
    }
}

struct OverviewHashed: View {
    var body: some View {
        OverviewContainer { data, imageView, likeButton in
            ZStack {
                if data.isEmpty {
                    ImagesCollectionView(images: Array([ImageModel].mocks.prefix(6)), imageView: imageView, likeButton: likeButton)
                        .redacted(reason: .placeholder)
                } else {
                    ImagesCollectionView(images: data, imageView: imageView, likeButton: likeButton)
                }
            }
            .animation(.easeInOut, value: data.isEmpty)
        } imageView: {
            ImageViewHash(data: $0)
        } likeButton: {
            LikeButtonLoading()
        }
    }
}

private struct OverviewContainer<CollectionView: View, ImageView: View, LikeButton: View>: View {
    @ViewBuilder var collectionView: ([ImageModel], @escaping (ImageModel) -> AnyView, @escaping () -> AnyView) -> CollectionView
    @ViewBuilder var imageView: (ImageModel) -> ImageView
    @ViewBuilder var likeButton: () -> LikeButton

    let client = APIClientLive()
    @State var images: [ImageModel] = []
    @State var loading = true

    var body: some View {
        collectionView(images, { AnyView(imageView($0)) }, { AnyView(likeButton()) } )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            loading = true
            images = await client.images()
            loading = false
        }
    }
}

//#Preview {
//    LoadingOverview() { ImageViewLoading(data: $0) } likeButton: { LikeButtonLoading() }
//}
