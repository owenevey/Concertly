import SwiftUI

struct ExploreRow<T: Codable & Identifiable>: View {
    
    let title: String
    let status: Status
    let data: [T]
    let contentType: ExploreContentType
    let onRetry: (() async -> Void)
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.system(size: 20, type: .SemiBold))
                .padding(.horizontal, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if status == .error {
                HStack {
                    Text("Error fetching \(contentType.title)")
                    Button("Retry") {
                        Task {
                            await onRetry()
                        }
                    }
                }
                .font(.system(size: 16, type: .Regular))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                .transition(.opacity)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    switch status {
                    case .loading, .empty:
                        if data.isEmpty {
                            renderFallbackCards(for: contentType)
                        } else {
                            renderCards(for: data)
                        }
                        
                    case .success:
                        if data.isEmpty {
                            renderErrorCards(for: contentType)
                        } else {
                            renderCards(for: data)
                        }
                        
                    case .error:
                        if data.isEmpty {
                            renderErrorCards(for: contentType)
                        } else {
                            renderCards(for: data)
                        }
                    }
                }
                .shadow(color: .black.opacity(0.2), radius: 5)
                .padding(.top, 10)
                .padding(.bottom, 20)
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
            }
        }
        
        if let destinations = data as? [Destination] {
            ForEach(destinations) { destination in
                DestinationCard(destination: destination)
            }
        }
        
        if let artists = data as? [SuggestedArtist] {
            ForEach(artists) { artist in
                ArtistCard(artist: artist)
            }
        }
        
        if let venues = data as? [Venue] {
            ForEach(venues) { venue in
                VenueCard(venue: venue)
            }
        }
    }
    
    @ViewBuilder
    private func renderFallbackCards(for contentType: ExploreContentType) -> some View {
        switch contentType {
        case .concert:
            ForEach(0..<6, id: \.self) { _ in
                FallbackConcertCard()
            }
        case .destination:
            ForEach(0..<6, id: \.self) { _ in
                FallbackDestinationCard()
            }
        case .artist:
            ForEach(0..<6, id: \.self) { _ in
                FallbackArtistCard()
            }
        case .venue:
            ForEach(0..<6, id: \.self) { _ in
                FallbackVenueCard()
            }
        }
    }
    
    @ViewBuilder
    private func renderErrorCards(for contentType: ExploreContentType) -> some View {
        switch contentType {
        case .concert:
            ForEach(0..<6, id: \.self) { _ in
                ErrorConcertCard()
            }
        case .destination:
            ForEach(0..<6, id: \.self) { _ in
                ErrorDestinationCard()
            }
        case .artist:
            ForEach(0..<6, id: \.self) { _ in
                ErrorArtistCard()
            }
        case .venue:
            ForEach(0..<6, id: \.self) { _ in
                ErrorVenueCard()
            }
        }
    }
}

#Preview {
    @Previewable @State var status: Status = .error
    NavigationStack {
        ScrollView {
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
            
        }
        .background(Color.background)
    }
    .background(Color.background)
    .environmentObject(Router())
    .environmentObject(AnimationManager())
}
