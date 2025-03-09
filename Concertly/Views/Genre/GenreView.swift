import SwiftUI

struct GenreView: View {
    @Environment(\.dismiss) var dismiss
    
    var genre: MusicGenre
    
    @StateObject var viewModel: GenreViewModel
    
    @State private var showHeaderBorder: Bool = false
    
    init(genre: MusicGenre) {
        self.genre = genre
        _viewModel = StateObject(wrappedValue: GenreViewModel(genre: genre))
    }
    
    @State private var hasAppeared: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    BackButton()
                    
                    HStack {
                        Text(genre.title)
                            .font(.system(size: 30, type: .SemiBold))
                        Text(genre.emoji)
                            .font(.system(size: 25))
                    }
                }
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .frame(height: 1.5)
                    .overlay(.gray2)
                    .opacity(showHeaderBorder ? 1 : 0)
                    .animation(.linear(duration: 0.1), value: showHeaderBorder)
            }
            .background(Color.background)
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ExploreRow(title: "Trending Concerts", status: viewModel.trendingConcertsResponse.status, data: viewModel.trendingConcerts, contentType: ExploreContentType.concert) {
                        await viewModel.getTrendingConcerts()
                    }
                    
                    ExploreRow(title: "Popular Artists", status: viewModel.popularArtistsResponse.status, data: viewModel.popularArtists, contentType: ExploreContentType.artist) {
                        await viewModel.getPopularArtists()
                    }
                    
                    FeaturedEvent(concert: viewModel.featuredConcert, status: viewModel.featuredConcertResponse.status) {
                        await viewModel.getFeaturedConcert()
                    }
                    
                    ExploreRow(title: "Suggested Concerts", status: viewModel.suggestedConcertsResponse.status, data: viewModel.suggestedConcerts, contentType: ExploreContentType.concert) {
                        await viewModel.getSuggestedConcerts()
                    }
                }
            }
            .background(Color.background)
            .onScrollGeometryChange(for: CGFloat.self) { geo in
                return geo.contentOffset.y
            } action: { oldValue, newValue in
                showHeaderBorder = newValue > 0
            }
        }
        .onAppear {
            if !hasAppeared {
                Task {
                    await viewModel.getTrendingConcerts()
                    await viewModel.getPopularArtists()
                    await viewModel.getFeaturedConcert()
                    await viewModel.getSuggestedConcerts()
                }
                hasAppeared = true
            }
        }
        .refreshable {
            Task {
                await viewModel.getTrendingConcerts()
                await viewModel.getPopularArtists()
                await viewModel.getFeaturedConcert()
                await viewModel.getSuggestedConcerts()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        GenreView(genre: MusicGenre.pop)
            .environmentObject(Router())
            .environmentObject(AnimationManager())
    }
}
