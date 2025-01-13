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
                    Button {
                        dismiss()
                    }
                    label: {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .padding(.horizontal, 15)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
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
                    .frame(height: 1)
                    .overlay(.gray2)
                    .opacity(showHeaderBorder ? 1 : 0)
                    .animation(.linear(duration: 0.1), value: showHeaderBorder)
            }
            .background(Color.background)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    ExploreRow(title: "Trending Concerts", status: viewModel.trendingConcertsResponse.status, data: viewModel.trendingConcerts, contentType: ExploreContentType.concert)
                    
                    ExploreRow(title: "Popular Artists", status: viewModel.popularArtistsResponse.status, data: viewModel.popularArtists, contentType: ExploreContentType.artist)
                    
                    FeaturedEvent(event: viewModel.featuredEvent, status: viewModel.featuredEventResponse.status)
                    
                    ExploreRow(title: "Suggested Concerts", status: viewModel.suggestedConcertsResponse.status, data: viewModel.suggestedConcerts, contentType: ExploreContentType.concert)
                }
            }
            .background(Color.background)
            .onScrollGeometryChange(for: CGFloat.self) { geo in
                return geo.contentOffset.y
            } action: { oldValue, newValue in
                withAnimation(.linear(duration: 0.3)) {
                    showHeaderBorder = newValue > 0
                }
            }
        }
        .onAppear {
            if !hasAppeared {
                Task {
                    await viewModel.getTrendingConcerts()
                    await viewModel.getPopularArtists()
                    await viewModel.getFeaturedEvent()
                    await viewModel.getSuggestedConcerts()
                }
                hasAppeared = true
            }
        }
        .refreshable {
            Task {
                await viewModel.getTrendingConcerts()
                await viewModel.getPopularArtists()
                await viewModel.getFeaturedEvent()
                await viewModel.getSuggestedConcerts()
            }
        }
    }
}

#Preview {
    GenreView(genre: MusicGenre.pop)
}
