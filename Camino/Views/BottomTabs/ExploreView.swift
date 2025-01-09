import SwiftUI

struct ExploreView: View {
    
    @StateObject var viewModel: ExploreViewModel = ExploreViewModel()
    @State private var concerts: [Concert] = []
    @State private var textInput = ""
    
    @State private var hasAppeared: Bool = false
    
    @State private var offset: CGFloat = 0
    @State private var isSearchBarVisible: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
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
                                    
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(Color.gray1)
                                        .shadow(color: .black.opacity(0.6), radius: 3)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                        .overlay(
                                            HStack {
                                                Image(systemName: "magnifyingglass")
                                                TextField("Search", text: $textInput)
                                                    .font(.system(size: 18, type: .Regular))
                                                    .padding(.trailing)
                                            }
                                                .padding()
                                        )
                                }
                                .frame(maxWidth: 800)
                                .padding(15)
                            }
                            .frame(height: 300)
                            
                            ExplorePills()
                            
                            ExploreRow(title: "Trending Concerts", status: viewModel.trendingConcertsResponse.status, data: viewModel.trendingConcerts, contentType: ExploreContentType.concert)
                            
                            ExploreRow(title: "Popular Destinations", status: viewModel.popularDestinationsResponse.status, data: viewModel.popularDestinations, contentType: ExploreContentType.place)
                            
                            ExploreRow(title: "Upcoming Games", status: viewModel.upcomingGamesResponse.status, data: viewModel.upcomingGames, contentType: ExploreContentType.game)
                            
                            FeaturedEvent(event: viewModel.featuredEvent, status: viewModel.featuredEventResponse.status)
                            
                            ExploreRow(title: "Suggested Concerts", status: viewModel.suggestedConcertsResponse.status, data: viewModel.suggestedConcerts, contentType: ExploreContentType.concert)
                            
                            
                            ExploreRow(title: "International Adventures", status: viewModel.popularDestinationsResponse.status, data: viewModel.popularDestinations, contentType: ExploreContentType.place)
                            
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
                    withAnimation {
                        if newValue > (300 - 15 - 50 - geometry.safeAreaInsets.top) {
                            isSearchBarVisible = false
                        } else {
                            isSearchBarVisible = true
                        }
                    }
                }
                
                Image(.zhangJiaJie)
                    .resizable()
                    .scaledToFill()
                    .zIndex(-1)
                    .frame(width: UIScreen.main.bounds.width, height: 300 + max(0, -offset))
                    .transformEffect(.init(translationX: 0, y: -max(0, offset)))
                
                if !isSearchBarVisible {
                    ExploreHeader()
                        .padding(.top, geometry.safeAreaInsets.top)
                }
                
            }
            .ignoresSafeArea(edges: .top)
        }
        .background(Color.background)
        .onAppear {
            if !hasAppeared {
                Task {
                    await viewModel.getTrendingConcerts()
                    await viewModel.getPopularDestinations()
                    await viewModel.getSuggestedConcerts()
                    await viewModel.getUpcomingGames()
                    await viewModel.getFeaturedEvent()
                }
                hasAppeared = true
            }
        }
        .refreshable {
            Task {
                await viewModel.getTrendingConcerts()
                await viewModel.getPopularDestinations()
                await viewModel.getSuggestedConcerts()
                await viewModel.getUpcomingGames()
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
