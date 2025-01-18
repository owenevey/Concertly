import SwiftUI

struct ArtistCard: View {
    @Namespace private var namespace
    let id = "UIElement"
    
    var artist: SuggestedArtist
    
    var body: some View {
        NavigationLink {
            ArtistView(artistID: artist.id)
                .navigationBarHidden(true)
                .navigationTransition(.zoom(sourceID: id, in: namespace))
        }
        label: {
            ImageLoader(url: artist.imageUrl, contentMode: .fill)
            .frame(width: 200, height: 230)
            .clipped()
            .overlay {
                ZStack(alignment: .bottom) {
                    LinearGradient(
                        colors: [
                            .black.opacity(0.8),
                            .clear
                        ],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text(artist.name)
                            .font(.system(size: 23, type: .SemiBold))
                            .foregroundStyle(.white)
                            .minimumScaleFactor(0.85)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(15)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(PlainButtonStyle())
        .matchedTransitionSource(id: id, in: namespace)
    }
}

#Preview {
    NavigationStack {
        ArtistCard(artist: SuggestedArtist(name: "Morgan Wallen", id: "K8vZ9174qlV", imageUrl: "https://s1.ticketm.net/dam/a/68c/b889729a-9af0-4a79-8c38-1b1ac86a868c_TABLET_LANDSCAPE_3_2.jpg"))
            .shadow(color: .black.opacity(0.2), radius: 5)
    }
}
