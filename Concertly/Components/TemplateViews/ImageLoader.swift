import SwiftUI
import SDWebImageSwiftUI

struct ImageLoader: View {
    let url: String
    var contentMode: ContentMode
    
    var body: some View {
        WebImage(url: URL(string: url)) { image in
                image.resizable()
            } placeholder: {
                Color.foreground
            }
            .aspectRatio(contentMode: contentMode)
    }
}

final class ImagePrefetcher {
    static let instance = ImagePrefetcher()
    private let prefetcher = SDWebImagePrefetcher()
    
    private init() {}
    
    func startPrefetching(urls: [URL]) {
        prefetcher.prefetchURLs(urls)
    }
    
    func stopPrefetching() {
        prefetcher.cancelPrefetching()
    }
}

#Preview {
    ImageLoader(url: "https://nokiatech.github.io/heif/content/images/ski_jump_1440x960.heic", contentMode: .fill)
        .frame(width: 200, height: 200)
        .clipped()
}
