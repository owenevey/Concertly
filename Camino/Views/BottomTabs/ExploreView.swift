import SwiftUI

struct ExploreView: View {
    
    @StateObject var viewModel: ExploreViewModel = ExploreViewModel()
    @State private var concerts: [Concert] = []
    @State private var textInput = ""
    
    @State private var hasAppeared: Bool = false
    
    var body: some View {
        ImageHeaderScrollView(headerContent: ExploreHeader(), showBackButton: false) {
            VStack(spacing: 15) {
                VStack {
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
                        
                        RoundedRectangle(cornerRadius: 20)
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
                                }.padding()
                            )
                    }
                    .padding(20)
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
            .padding(.bottom, 90)
            .padding(.top, -300)
            .background(Color.background)
        }
        .background(Color.background)
        .ignoresSafeArea(edges: .top)
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
