import SwiftUI

struct ExploreView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ExploreViewModel
    
    @State private var offset: CGFloat = 0
    @State private var isSearchBarVisible: Bool = true
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image(colorScheme == .light ? .exploreBlobLight : .exploreBlobDark)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: 250 + max(0, -offset - geometry.safeAreaInsets.top))
                    .scaledToFill()
                    .transformEffect(.init(translationX: 0, y: -max(0, offset + geometry.safeAreaInsets.top)))
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        HStack(alignment: .top) {
                            Text("Concertly")
                                .font(.system(size: 30, type: .Bold))
                                .foregroundStyle(.accent)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            NavigationLink(value: Routes.notifications.rawValue) {
                                Circle()
                                    .fill(Color.foreground)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Image(systemName: "bell")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .shadow(color: .black.opacity(0.1), radius: 5)
                        .padding(.horizontal, 15)
                        .frame(width: UIScreen.main.bounds.width)
                        
                        NavigationLink(value: Routes.exploreSearch.rawValue) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .fontWeight(.semibold)
                                Text("Search Artists")
                                    .font(.system(size: 17, type: .Regular))
                                    .foregroundStyle(.gray3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.foreground)
                                    .shadow(color: .black.opacity(0.2), radius: 5)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 15)
                        
                        LazyVStack(spacing: 0) {
                            VStack(spacing: 0) {
                                Text("Explore by Category")
                                    .font(.system(size: 20, type: .SemiBold))
                                    .padding(.horizontal, 15)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                GenrePills()
                            }
                            
                            ExploreRow(title: "Trending Concerts", status: viewModel.trendingConcertsResponse.status, data: viewModel.trendingConcerts, contentType: ExploreContentType.concert) {
                                await viewModel.getTrendingConcerts()
                            }
                            
                            ExploreRow(title: "Popular Artists", status: viewModel.popularArtistsResponse.status, data: viewModel.popularArtists, contentType: ExploreContentType.artist) {
                                await viewModel.getPopularArtists()
                            }
                            
                            if case viewModel.similarConcertsResponse.status = .success, !viewModel.similarConcerts.isEmpty {
                                ExploreRow(title: "Because you like \(viewModel.similarConcertsArtist)", status: viewModel.similarConcertsResponse.status, data: viewModel.similarConcerts, contentType: ExploreContentType.concert) {
                                    await viewModel.getSimilarConcerts()
                                }
                            }
                            
                            ExploreRow(title: "Popular Destinations", status: viewModel.popularDestinationsResponse.status, data: viewModel.popularDestinations, contentType: ExploreContentType.destination) {
                                await viewModel.getPopularDestinations()
                            }
                            
                            FeaturedEvent(concert: viewModel.featuredConcert, status: viewModel.featuredConcertResponse.status) {
                                await viewModel.getFeaturedConcert()
                            }
                            
                            ExploreRow(title: "Suggested Concerts", status: viewModel.suggestedConcertsResponse.status, data: viewModel.suggestedConcerts, contentType: ExploreContentType.concert) {
                                await viewModel.getSuggestedConcerts()
                            }
                            
                            ExploreRow(title: "Famous Venues", status: viewModel.famousVenuesResponse.status, data: viewModel.famousVenues, contentType: ExploreContentType.venue) {
                                await viewModel.getFamousVenues()
                            }
                        }
                    }
                }
                .padding(.top, geometry.safeAreaInsets.top)
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    return geo.contentOffset.y
                } action: { oldValue, newValue in
                    offset = newValue
                    withAnimation(.linear(duration: 0.1)) {
                        if newValue > -(geometry.safeAreaInsets.top - 40) {
                            isSearchBarVisible = false
                        } else {
                            isSearchBarVisible = true
                        }
                    }
                }
                ExploreHeader()
                    .opacity(isSearchBarVisible ? 0 : 1)
                    .padding(.top, geometry.safeAreaInsets.top)
            }
            .ignoresSafeArea(edges: .top)
        }
        .background(Color.background)
        .refreshable {
            Task {
                await viewModel.getTrendingConcerts()
                await viewModel.getSimilarConcerts()
                await viewModel.getPopularArtists()
                await viewModel.getPopularDestinations()
                await viewModel.getFeaturedConcert()
                await viewModel.getSuggestedConcerts()
                await viewModel.getFamousVenues()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExploreView(viewModel: ExploreViewModel())
            .environmentObject(Router())
            .environmentObject(AnimationManager())
    }
}
