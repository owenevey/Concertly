import SwiftUI

struct ExploreRow<Data: RandomAccessCollection>: View {
    
    let title: String
    let data : Data
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(title)
                    .font(.system(size: 23, type: .SemiBold))
                Spacer()
            }
            .padding(.horizontal, 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    if let places = data as? [Place] {
                        ForEach(places, id: \.id) { place in
                            PlaceCard(place: place)
                                .shadow(color: .black.opacity(0.2), radius: 5)
                        }
                    } else if let concerts = data as? [Concert] {
                        ForEach(concerts, id: \.id) { concert in
                            ConcertCard(concert: concert)
                                .shadow(color: .black.opacity(0.2), radius: 5)
                        }
                    } else if let games = data as? [Game] {
                        ForEach(games, id: \.id) { game in
                            SportCard(game: game)
                                .shadow(color: .black.opacity(0.2), radius: 5)
                        }
                    }
                }
                .padding(.vertical, 15)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.horizontal, 15)
        }
    }
}

#Preview {
    NavigationStack {
        ExploreRow(title: "Suggested Places", data: suggestedPlaces)
    }
}
