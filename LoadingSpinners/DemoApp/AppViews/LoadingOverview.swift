import SwiftUI
import Core

struct OverviewLoadingBlocked: View {
    @State var showLoadingAndBlockUI = false

    var body: some View {
        OverviewContainer { data, imageView, remixButton, likeButton in
            ImagesCollectionView(images: data, imageView: imageView, remixButton: remixButton, likeButton: likeButton)
                .onChange(of: data.isEmpty, initial: true) { oldValue, isEmpty in
                    if isEmpty {
                        showLoadingAndBlockUI = true
                    } else {
                        Task {
                            try? await Task.sleep(for: .seconds(4))
                            showLoadingAndBlockUI = false
                        }
                    }
                }
        } imageView: {
            ImageViewBlocked(data: $0)
        } remixButton: {
            RemixButtonBlocked {
                showLoadingAndBlockUI = $0
            }
        } likeButton: {
            LikeButtonBlocked {
                showLoadingAndBlockUI = $0
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(!showLoadingAndBlockUI)
        .overlay {
            if showLoadingAndBlockUI {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.8))
                    .frame(width: 200, height: 200)
                    .overlay {
                        LoadingView(size: .large)
                    }
            }
        }
    }
}

struct OverviewLoading: View {
    var body: some View {
        OverviewContainer { data, imageView, remixButton, likeButton in
            ImagesCollectionView(images: data, imageView: imageView, remixButton: remixButton, likeButton: likeButton)
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
        } remixButton: {
            RemixButton()
        } likeButton: {
            LikeButtonLoading()
        }
    }
}

struct OverviewRedacted: View {
    var body: some View {
        OverviewContainer { data, imageView, remixButton, likeButton in
            ZStack {
                if data.isEmpty {
                    ImagesCollectionView(images: Array([ImageModel].mocks.prefix(6)), imageView: imageView, remixButton: remixButton, likeButton: likeButton)
                        .redacted(reason: .placeholder)
                        .allowsHitTesting(false)
                } else {
                    ImagesCollectionView(images: data, imageView: imageView, remixButton: remixButton, likeButton: likeButton)
                }
            }
            .animation(.easeInOut, value: data.isEmpty)
        } imageView: {
            ImageViewRedacted(data: $0)
        } remixButton: {
            RemixButton()
        } likeButton: {
            LikeButtonLoading()
        }
    }
}

struct OverviewHashed: View {
    var body: some View {
        OverviewContainer { data, imageView, remixButton, likeButton in
            ZStack {
                if data.isEmpty {
                    ImagesCollectionView(images: Array([ImageModel].mocks.prefix(6)), imageView: imageView, remixButton: remixButton, likeButton: likeButton)
                        .redacted(reason: .placeholder)
                } else {
                    ImagesCollectionView(images: data, imageView: imageView, remixButton: remixButton, likeButton: likeButton)
                }
            }
            .animation(.easeInOut, value: data.isEmpty)
        } imageView: {
            ImageViewHash(data: $0)
        } remixButton: {
            RemixButton()
        } likeButton: {
            LikeButtonLoading()
        }
    }
}

struct OverviewAnimated: View {
    var body: some View {
        OverviewContainer { data, imageView, remixButton, likeButton in
            ZStack {
                if data.isEmpty {
                    ImagesCollectionView(images: Array([ImageModel].mocks.prefix(6)), imageView: imageView, remixButton: remixButton, likeButton: likeButton)
                        .redacted(reason: .placeholder)
                } else {
                    ImagesCollectionView(images: data, imageView: imageView, remixButton: remixButton, likeButton: likeButton)
                }
            }
            .animation(.easeInOut, value: data.isEmpty)
        } imageView: {
            ImageViewHash(data: $0)
        } remixButton: {
            RemixButtonProgress()
        } likeButton: {
            LikeButtonAnimation()
        }
    }
}

struct OverviewNavigation: View {
    @State private var path = NavigationPath()
    @Namespace private var namespace

    var body: some View {
        NavigationStack(path: $path) {
            OverviewContainer { data, imageView, remixButton, likeButton in
                ZStack {
                    if data.isEmpty {
                        ImagesCollectionView(images: Array([ImageModel].mocks.prefix(6)), imageView: imageView, remixButton: remixButton, likeButton: likeButton)
                            .redacted(reason: .placeholder)
                    } else {
                        ImagesCollectionView(images: data, imageView: imageView, remixButton: remixButton, likeButton: likeButton)
                    }
                }
                .animation(.easeInOut, value: data.isEmpty)
            } imageView: { data in
                DeferredNavigationLink(path: $path, value: data) {
                    ImageViewHash(data: data)
                }
            } remixButton: {
                RemixButton()
            } likeButton: {
                LikeButtonAnimation()
            }
            .navigationDestination(for: ImageModel.self) { data in
                DetailView(data: data, namespace: namespace)
            }
        }
    }
}

struct OverviewNavigationCustom: View {
    @State private var detail: ImageModel?
    @Namespace private var namespace
    var body: some View {
        ZStack {
            OverviewContainer { data, imageView, remixButton, likeButton in
                ZStack {
                    if data.isEmpty {
                        ImagesCollectionView(images: Array([ImageModel].mocks.prefix(6)), imageView: imageView, remixButton: remixButton, likeButton: likeButton)
                            .redacted(reason: .placeholder)
                    } else {
                        ImagesCollectionView(images: data, imageView: imageView, remixButton: remixButton, likeButton: likeButton)
                    }
                }
                .animation(.easeInOut, value: data.isEmpty)
            } imageView: { data in
                if detail == nil {
                    Button {
                        withAnimation {
                            detail = data
                        }
                    } label: {
                        ImageViewHash(data: data)
                            .matchedGeometryEffect(id: "imageview:\(data.id)", in: namespace)
                    }
                } else {
                    ImageViewHash(data: data).hidden()
                }
            } remixButton: {
                RemixButton()
            } likeButton: {
                LikeButtonAnimation()
            }

            if let detail {
                DetailView(data: detail, namespace: namespace)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.background)
                    .onTapGesture {
                        withAnimation {
                            self.detail = nil
                        }
                    }
            }
        }
    }
}

struct DetailView: View {
    let data: ImageModel
    let namespace: Namespace.ID
    @State private var loaded = false


    var body: some View {
        VStack {
            HStack(spacing: 20) {
                ImageProvider().load().first(where: {$0.id == data.id})?
                    .image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 12))
                    .matchedGeometryEffect(id: "imageview:\(data.id)", in: namespace)

                VStack(alignment: .leading) {
                    Text(data.title)
                        .font(.largeTitle)

                    Text(data.prompt)
                        .font(.title3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .redacted(reason: loaded ? [] : .placeholder)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            try? await Task.sleep(for: .seconds(1))
            loaded = true
        }
    }
}

private struct DeferredNavigationLink<Label: View, Value: Identifiable & Hashable>: View {
    @Binding var path: NavigationPath
    var value: Value
    @ViewBuilder var label: () -> Label
    var body: some View {
        Button {
            Task {
                try? await Task.sleep(for: .milliseconds(150))
                path.append(value)
            }
        } label: {
            label()
        }
    }
}


private struct OverviewContainer<CollectionView: View, ImageView: View, RemixButton: View, LikeButton: View>: View {
    @ViewBuilder var collectionView: ([ImageModel], @escaping (ImageModel) -> AnyView, @escaping () -> AnyView, @escaping () -> AnyView) -> CollectionView
    @ViewBuilder var imageView: (ImageModel) -> ImageView
    @ViewBuilder var remixButton: () -> RemixButton
    @ViewBuilder var likeButton: () -> LikeButton

    let client = APIClientLive()
    @State var images: [ImageModel] = []
    @State var loading = true

    var body: some View {
        collectionView(images, { AnyView(imageView($0)) }, { AnyView(remixButton()) }, { AnyView(likeButton()) } )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            loading = true
            images = await client.images()
            loading = false
        }
    }
}

#Preview {
    OverviewNavigation()
}
