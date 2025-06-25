import SwiftUI

private struct CachedAsyncImage: View {
    let url: URL
    let color: Color?
    @State private var image: UIImage?
    @State private var loaded = false

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .opacity(loaded ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            self.loaded = true
                        }
                    }
            } else {
                (color ?? Color.gray)
                    .opacity(1)
                    .transition(.opacity)
                    .onAppear {
                        loadImage()
                    }
            }
        }
        .clipped()
    }

    private func loadImage() {
        let request = URLRequest(url: url)
        if let cached = ImageCache.cache.cachedResponse(for: request),
           let uiImage = UIImage(data: cached.data) {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.image = uiImage
                self.loaded = true
            }
        } else {
            URLSession.shared.dataTask(with: request) { data, response, _ in
                if let data = data, let response = response,
                   let uiImage = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    ImageCache.cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            self.image = uiImage
                            self.loaded = true
                        }
                    }
                }
            }.resume()
        }
    }
}

struct PhotoView: View {
    let photo: UnsplashPhoto
    let showsUsername: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let url = sizedImageURL(from: photo.urls[.regular]) {
                CachedAsyncImage(url: url, color: Color(photo.color ?? .gray))
            } else {
                Color(photo.color ?? .gray)
            }

            if showsUsername {
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.5)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 60)
                .overlay(
                    Text(photo.user.displayName)
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .padding([.leading, .bottom], 8),
                    alignment: .bottomLeading
                )
            }
        }
        .accessibilityIgnoresInvertColors(true)
        .cornerRadius(6)
        .clipped()
    }

    private func sizedImageURL(from url: URL?) -> URL? {
        guard let url else { return nil }
        let scale = Int(UIScreen.main.scale)
        let width = Int(UIScreen.main.bounds.width)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "w", value: "\(width)"),
            URLQueryItem(name: "dpr", value: "\(scale)")
        ]
        return components?.url
    }
}
