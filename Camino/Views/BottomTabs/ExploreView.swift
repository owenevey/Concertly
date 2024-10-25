import SwiftUI

struct ExploreView: View {
    
    @State private var concerts: [Concert] = []
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 15) {
                ExploreHeader()
                ExplorePills()
                ExploreRow(title: "Suggested Places", data: suggestedPlaces)
                ExploreRow(title: "Trending Concerts", data: concerts)
                ExploreRow(title: "Upcoming Games", data: upcomingGames)
            }
            .padding(.bottom, 90)
        }
        .background(Color("Background"))
        .ignoresSafeArea(edges: .top)
        .task {
            do {
                concerts = try await fetchConcertsFromAPI()
            } catch {
                print("Error fetching concerts")
            }
        }
        .refreshable {
            do {
                concerts = try await fetchConcertsFromAPI()
            } catch {
                print("Error fetching concerts")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExploreView()
    }
}
