import SwiftUI

struct ExploreRow<T: Codable & Identifiable>: View {
    
    let title: String
    let status: Status
    let data: [T]
    let contentType: ExploreContentType
    let onRetry: (() async -> Void)
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(title)
                    .font(.system(size: 23, type: .SemiBold))
                Spacer()
            }
            .padding(.horizontal, 15)
            
            if status == .error {
                HStack {
                    Text("Error fetching \(contentType.title)")
                    Button("Retry") {
                        Task {
                            await onRetry()
                        }
                    }
                }
                .font(.system(size: 18, type: .Regular))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                .transition(.opacity)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    switch status {
                    case .loading, .empty:
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
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 15)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.horizontal, 15)
        }
        .animation(.easeInOut, value: status)
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
        
        if let artists = data as? [SuggestedArtist] {
            ForEach(artists) { artist in
                ArtistCard(artist: artist)
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
        }
        
        if let venues = data as? [Venue] {
            ForEach(venues) { venue in
                VenueCard(venue: venue)
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
        case .artist:
            ForEach(0..<6, id: \.self) { _ in
                FallbackArtistCard()
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
        case .venue:
            ForEach(0..<6, id: \.self) { _ in
                FallbackVenueCard()
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
        case .artist:
            ForEach(0..<6, id: \.self) { _ in
                ErrorArtistCard()
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
        case .venue:
            ForEach(0..<6, id: \.self) { _ in
                ErrorVenueCard()
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
        }
    }
}

#Preview {
    @Previewable @State var status: Status = .error
    NavigationStack {
        VStack {
            Spacer()
            
            ExploreRow(
                title: "Trending Concerts",
                status: status,
                data: [
                    hotConcerts[0], hotConcerts[0], hotConcerts[0],
                ],
                contentType: .concert,
                onRetry: {
                    Task {
                        status = .loading
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        status = .error
                    }
                }
            )
            
            Spacer()
        }
        .background(Color.background)
    }
    .background(Color.background)
    
}
