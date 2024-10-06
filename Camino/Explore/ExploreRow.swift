import SwiftUI

struct ExploreRow<Data: RandomAccessCollection>: View {
    
    let title: String
    let data : Data
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text(title)
                    .font(Font.custom("Barlow-Bold", size: 23))
                Spacer()
            }
            .padding(.horizontal, 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    if let places = data as? [Place] {
                        ForEach(places, id: \.id) { place in
                            PlaceCard(place: place)
                        }
                    } else if let concerts = data as? [Concert] {
                        ForEach(concerts, id: \.id) { concert in
                            ConcertCard(concert: concert)
                        }
                    } else if let games = data as? [Game] {
                        ForEach(games, id: \.id) { game in
                            SportCard(game: game)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.horizontal, 15)
        }
    }
}

#Preview {
    NavigationStack {
        ExploreRow(title: "Suggested Places", data: hotConcerts)
    }
}
