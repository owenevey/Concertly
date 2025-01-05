import SwiftUI

struct ExploreRow<T: Codable & Identifiable>: View {
    
    let title: String
    let status: Status
    let data: [T]
    let contentType: ExploreContentType
    
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
                    switch status {
                    case .loading:
                        if data.isEmpty {
                            renderFallbackCards(for: contentType)
                        } else {
                            renderCards(for: data)
                        }
                        
                    case .success:
                        renderCards(for: data)
                        
                    case .error:
                        if data.isEmpty {
                            renderErrorCards(for: contentType)
                        } else {
                            renderErrorCards(for: contentType)
//                            renderCards(for: data) NOTE: Keep for debugging
                        }
                        
                    case .empty:
                        if data.isEmpty {
                            renderFallbackCards(for: contentType)
                        } else {
                            renderCards(for: data)
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
    
    @ViewBuilder
    private func renderCards(for data: Any) -> some View {
        if let concerts = data as? [Concert] {
            ForEach(concerts) { concert in
                ConcertCard(concert: concert)
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
        }
        
        if let places = data as? [Place] {
            ForEach(places) { place in
                PlaceCard(place: place)
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
        }
        
        if let games = data as? [Game] {
            ForEach(games) { game in
                GameCard(game: game)
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
        }
    }
    
    @ViewBuilder
    private func renderFallbackCards(for contentType: ExploreContentType) -> some View {
        switch contentType {
        case .concert:
            ForEach(0..<6, id: \.self) { _ in
                FallbackConcertCard()
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
        case .place:
            ForEach(0..<6, id: \.self) { _ in
                FallbackPlaceCard()
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
        case .game:
            ForEach(0..<6, id: \.self) { _ in
                FallbackGameCard()
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
        }
    }
    
    @ViewBuilder
    private func renderErrorCards(for contentType: ExploreContentType) -> some View {
        switch contentType {
        case .concert:
            ForEach(0..<6, id: \.self) { _ in
                ErrorConcertCard()
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
        case .place:
            ForEach(0..<6, id: \.self) { _ in
                ErrorPlaceCard()
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
        case .game:
            ForEach(0..<6, id: \.self) { _ in
                ErrorGameCard()
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        ExploreRow(title: "Suggested Places", data: suggestedPlaces)
//    }
//}
