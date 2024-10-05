import SwiftUI

struct ExploreView: View {
    
    
    @State private var concerts: [Concert] = []
    
    var body: some View {
        ZStack {
            NavigationStack{
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        ExploreHeader()
                        ExplorePills()
                        SuggestedPlaces()
                        TrendingConcerts(concerts: concerts)
                        UpcomingGames()
                        
                    }
                    .padding(.bottom, 90)
                }
                .background(Color("Background"))
                .ignoresSafeArea(edges: .top)
            }
            .task {
                do {
                    concerts = try await fetchConcertsFromAPI()
                } catch {
                    
                }
            }
        }
        
    }
}

#Preview {
    ExploreView()
}
