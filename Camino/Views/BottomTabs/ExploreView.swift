import SwiftUI

struct ExploreView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ExploreViewModel = ExploreViewModel()
    
    @State private var hasAppeared: Bool = false
    @State private var offset: CGFloat = 0
    @State private var isSearchBarVisible: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image(colorScheme == .dark ? .concert : .acl)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 300 + max(0, -offset))
                    .transformEffect(.init(translationX: 0, y: -max(0, offset)))
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                        
                        VStack(spacing: 15) {
                            VStack {
                                HStack {
                                    Image(systemName: "bell")
                                        .font(.system(size: 20))
                                        .fontWeight(.semibold)
                                        .background(
                                            Circle()
                                                .fill(Color.foreground)
                                                .frame(width: 40, height: 40)
                                        )
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.horizontal, 30)
                                .padding(.top, geometry.safeAreaInsets.top)
                                .offset(y: min(offset, 0))
                                
                                Spacer()
                                
                                VStack(spacing: 15) {
                                    HStack {
                                        Text("What adventures\nawait?")
                                            .font(.system(size: 30, type: .Bold))
                                            .foregroundStyle(.white)
                                            .frame(alignment: .leading)
                                            .shadow(color: .black.opacity(0.6), radius: 3)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    NavigationLink {
                                        ExploreSearchView()
                                            .navigationBarHidden(true)
                                    } label: {
                                        HStack {
                                            Image(systemName: "magnifyingglass")
                                                .fontWeight(.semibold)
                                            Text("Search Artists")
                                                .font(.system(size: 17, type: .Regular))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .padding(.vertical, 12)
                                        .padding(.horizontal, 15)
                                        .background(
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(Color.gray1)
                                                .shadow(color: .black.opacity(0.6), radius: 3)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(15)
                                .frame(maxWidth: 800)
                                
                            }
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            
                            LazyVStack(spacing: 15) {
                                
                                GenrePills()
                                
                                ExploreRow(title: "Trending Concerts", status: viewModel.trendingConcertsResponse.status, data: viewModel.trendingConcerts, contentType: ExploreContentType.concert) {
                                    await viewModel.getTrendingConcerts()
                                }
                                
                                ExploreRow(title: "Popular Artists", status: viewModel.popularArtistsResponse.status, data: viewModel.popularArtists, contentType: ExploreContentType.artist) {
                                    await viewModel.getPopularArtists()
                                }
                                
                                ExploreRow(title: "Popular Destinations", status: viewModel.popularDestinationsResponse.status, data: viewModel.popularDestinations, contentType: ExploreContentType.destination) {
                                    await viewModel.getPopularDestinations()
                                }
                                
                                FeaturedEvent(event: viewModel.featuredEvent, status: viewModel.featuredEventResponse.status) {
                                    await viewModel.getFeaturedEvent()
                                }
                                
                                ExploreRow(title: "Suggested Concerts", status: viewModel.suggestedConcertsResponse.status, data: viewModel.suggestedConcerts, contentType: ExploreContentType.concert) {
                                    await viewModel.getSuggestedConcerts()
                                }
                                
                                ExploreRow(title: "Famous Venues", status: viewModel.famousVenuesResponse.status, data: viewModel.famousVenues, contentType: ExploreContentType.venue) {
                                    await viewModel.getFamousVenues()
                                }
                            }
                        }
                        .padding(.top, -300)
                    }
                }
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    return geo.contentOffset.y
                } action: { oldValue, newValue in
                    offset = newValue
                    withAnimation(.linear(duration: 0.1)) {
                        if newValue > (300 - 15 - 50 - geometry.safeAreaInsets.top) {
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
        .onAppear {
            if !hasAppeared {
                Task {
                    await viewModel.getTrendingConcerts()
                    await viewModel.getPopularArtists()
                    await viewModel.getPopularDestinations()
                    await viewModel.getFeaturedEvent()
                    await viewModel.getSuggestedConcerts()
                    await viewModel.getFamousVenues()
                }
                hasAppeared = true
            }
        }
        .refreshable {
            Task {
                await viewModel.getTrendingConcerts()
                await viewModel.getPopularArtists()
                await viewModel.getPopularDestinations()
                await viewModel.getFeaturedEvent()
                await viewModel.getSuggestedConcerts()
                await viewModel.getFamousVenues()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExploreView()
    }
}
