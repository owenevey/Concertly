import SwiftUI

struct VenueCard: View {
    @Namespace private var namespace
    let id = "UIElement"
    
    
    var venue: Venue
    
    var body: some View {
        NavigationLink {
//            ArtistView(artistID: artist.id)
//                .navigationBarHidden(true)
//                .navigationTransition(.zoom(sourceID: id, in: namespace))
        }
        label: {
            ImageLoader(url: venue.imageUrl, contentMode: .fill)
            .frame(width: 250, height: 200)
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
                        Spacer()
                        Text(venue.name)
                            .font(.system(size: 23, type: .SemiBold))
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(15)
                    }
                }
            }
            .cornerRadius(20)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .matchedTransitionSource(id: id, in: namespace)
        
    }
}

#Preview {
    NavigationStack {
        VStack {
            Spacer()
            VenueCard(venue: Venue(
                id: "KovZpZA7AAEA",
                name: "Madison Square Garden",
                imageUrl: "https://upload.wikimedia.org/wikipedia/commons/4/4b/Madison_Square_Garden_%28MSG%29_-_Full_%2848124330357%29.jpg",
                cityName: "New York, NY",
                countryName: "United States",
                latitude: 40.74970620,
                longitude: -73.99160060,
                description: "Located in the heart of Manhattan, this iconic arena has hosted countless legendary performances, unforgettable concerts, and historic events. Known for its electric atmosphere and world-class acoustics, it’s a destination where music lovers and fans gather to witness once-in-a-lifetime moments in entertainment history."
            ))
            .shadow(color: .black.opacity(0.2), radius: 5)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.background)
    }
}
