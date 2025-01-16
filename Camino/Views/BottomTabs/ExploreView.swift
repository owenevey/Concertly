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
                            .frame(height: 300)
                        
                        VStack(spacing: 15) {
                            VStack {
                                HStack {
                                    Spacer()
                                    Image(systemName: "bell")
                                        .font(.system(size: 20))
                                        .fontWeight(.semibold)
                                        .background(
                                            Circle()
                                                .fill(Color.foreground)
                                                .frame(width: 40, height: 40)
                                        )
                                    
                                }
                                .padding(.horizontal, 30)
                                .padding(.top, geometry.safeAreaInsets.top)
                                .offset(y: min(offset, 0))
                                
                                Spacer()
                                
                                VStack {
                                    HStack {
                                        Text("What adventures\nawait?")
                                            .font(.system(size: 30, type: .Bold))
                                            .foregroundStyle(.white)
                                            .frame(alignment: .leading)
                                            .shadow(color: .black.opacity(0.6), radius: 3)
                                        Spacer()
                                    }
                                    
                                    NavigationLink {
                                        ExploreSearchView()
                                            .navigationBarHidden(true)
                                    } label: {
                                        HStack {
                                            Image(systemName: "magnifyingglass")
                                                .fontWeight(.semibold)
                                            Text("Search Artists")
                                                .font(.system(size: 18, type: .Regular))
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
                            .frame(height: 300)
                            
                            ExplorePills()
                            
                            LazyVStack {
                                ExploreRow(title: "Trending Concerts", status: viewModel.trendingConcertsResponse.status, data: viewModel.trendingConcerts, contentType: ExploreContentType.concert) {
                                    await viewModel.getTrendingConcerts()
                                }
                                
                                ExploreRow(title: "Popular Artists", status: viewModel.popularArtistsResponse.status, data: viewModel.popularArtists, contentType: ExploreContentType.artist) {
                                    await viewModel.getPopularArtists()
                                }
                                
                                ExploreRow(title: "Popular Destinations", status: viewModel.popularDestinationsResponse.status, data: viewModel.popularDestinations, contentType: ExploreContentType.place) {
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
                        .background(Color.background)
                    }
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size
                    }
                }
                .ignoresSafeArea(edges: .top)
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
                    .animation(.linear(duration: 0.1), value: isSearchBarVisible)
                    .padding(.top, geometry.safeAreaInsets.top)
            }
            .ignoresSafeArea(edges: .top)
        }
        .background(Color.background)
        .onAppear {
            if !hasAppeared {
                Task {
                    await viewModel.getFamousVenues()
                    await viewModel.getTrendingConcerts()
                    await viewModel.getPopularDestinations()
                    await viewModel.getSuggestedConcerts()
                    await viewModel.getPopularArtists()
                    await viewModel.getFeaturedEvent()
                }
                hasAppeared = true
            }
        }
        .refreshable {
            Task {
                await viewModel.getFamousVenues()
                await viewModel.getTrendingConcerts()
                await viewModel.getPopularDestinations()
                await viewModel.getSuggestedConcerts()
                await viewModel.getPopularArtists()
                await viewModel.getFeaturedEvent()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExploreView()
    }
}
