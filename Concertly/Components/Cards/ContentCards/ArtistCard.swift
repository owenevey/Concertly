import SwiftUI
import SmoothGradient

struct ArtistCard: View {
    @EnvironmentObject var animationManager: AnimationManager

    var artist: SuggestedArtist
    
    var body: some View {
        NavigationLink(value: ZoomArtistLink(artist: artist)) {
            ImageLoader(url: artist.imageUrl, contentMode: .fill)
            .frame(width: 200, height: 230)
            .clipped()
            .contentShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                ZStack(alignment: .bottom) {
                    SmoothLinearGradient(
                        from: .clear,
                        to: .black.opacity(0.8),
                        startPoint: .top,
                        endPoint: .bottom,
                        curve: .easeInOut)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text(artist.name)
                            .font(.system(size: 23, type: .SemiBold))
                            .foregroundStyle(.white)
                            .minimumScaleFactor(0.9)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 15)
                            .padding(.bottom, 10)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .matchedTransitionSource(id: artist.id, in: animationManager.animation) {
                $0
                    .background(.clear)
                    .clipShape(.rect(cornerRadius: 20))
            }
        }
        .buttonStyle(PlainButtonStyle())
//        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 20))
//        .contextMenu {
//            let isFollowing = CoreDataManager.shared.isFollowingArtist(id: artist.id)
//            if isFollowing {
//                Button {
//                    CoreDataManager.shared.unSaveArtist(id: artist.id, category: ContentCategories.following.rawValue)
//                } label: {
//                    Label("Unfollow", systemImage: "xmark")
//                }
//            }
//            else {
//                Button {
//                    CoreDataManager.shared.saveArtist(artist, category: ContentCategories.following.rawValue)
//                } label: {
//                    Label("Follow", systemImage: "star.fill")
//                }
//            }
//        }
    }
}

#Preview {
    NavigationStack {
        ArtistCard(artist: SuggestedArtist(name: "Morgan Wallen", id: "K8vZ9174qlV", imageUrl: "https://s1.ticketm.net/dam/a/68c/b889729a-9af0-4a79-8c38-1b1ac86a868c_TABLET_LANDSCAPE_3_2.jpg"))
            .shadow(color: .black.opacity(0.2), radius: 5)
    }
}
