import SwiftUI

struct ContentView: View {
    @AppStorage(AppStorageKeys.theme.rawValue) private var theme = "Default"
    @AppStorage(AppStorageKeys.homeAirport.rawValue) private var homeAirport = ""
    @AppStorage(AppStorageKeys.homeCity.rawValue) private var homeCity = ""
    
    @ObservedObject var exploreViewModel = ExploreViewModel()
    @ObservedObject var nearbyViewModel = NearbyViewModel()
    @ObservedObject var savedViewModel = SavedViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
            Group {
                NavigationStack(path: $router.explorePath) {
                    ExploreView(viewModel: exploreViewModel)
                        .navigationDestinations(homeAirport: $homeAirport, homeCity: $homeCity)
                }
                .tabItem {
                    Label("Explore", systemImage: "globe.americas")
                }
                .tag(0)
                
                NavigationStack(path: $router.nearbyPath) {
                    NearbyView(viewModel: nearbyViewModel)
                        .navigationDestinations(homeAirport: $homeAirport, homeCity: $homeCity)
                }
                .tabItem {
                    Label("Nearby", systemImage: "location")
                }
                .tag(1)
                
                NavigationStack(path: $router.savedPath) {
                    SavedView(viewModel: savedViewModel)
                        .navigationDestinations(homeAirport: $homeAirport, homeCity: $homeCity)
                }
                .tabItem {
                    Label("Saved", systemImage: "bookmark.fill")
                }
                .tag(2)
                
                NavigationStack(path: $router.profilePath) {
                    ProfileView(profileViewModel: profileViewModel, nearbyViewModel: nearbyViewModel)
                        .navigationDestinations(homeAirport: $homeAirport, homeCity: $homeCity)
                }
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(3)
            }
            .toolbarBackground(Color.background, for: .tabBar)
        }
        .preferredColorScheme(theme == "Light" ? .light : (theme == "Dark" ? .dark : nil))
    }
}

struct NavigationDestinationModifier: ViewModifier {
    @EnvironmentObject var router: Router
    @EnvironmentObject var animationManager: AnimationManager
    @Binding var homeAirport: String
    @Binding var homeCity: String
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: ZoomConcertLink.self) { item in
                ConcertView(concert: item.concert)
                    .navigationTransition(.zoom(sourceID: item.concert.id, in: animationManager.animation))
            }
            .navigationDestination(for: Concert.self) { concert in
                ConcertView(concert: concert)
            }
            .navigationDestination(for: ZoomArtistLink.self) { item in
                ArtistView(artistID: item.artist.id)
                    .navigationTransition(.zoom(sourceID: item.artist.id, in: animationManager.animation))
            }
            .navigationDestination(for: SuggestedArtist.self) { artist in
                ArtistView(artistID: artist.id)
            }
            .navigationDestination(for: Destination.self) { destination in
                DestinationView(destination: destination)
                    .navigationTransition(.zoom(sourceID: destination.id, in: animationManager.animation))
            }
            .navigationDestination(for: Venue.self) { venue in
                VenueView(venue: venue)
                    .navigationTransition(.zoom(sourceID: venue.id, in: animationManager.animation))
            }
            .navigationDestination(for: [SuggestedArtist].self) { lineup in
                FullLineupView(lineup: lineup, title: router.profilePath.count == 1 ? "Following" : "Lineup")
            }
            .navigationDestination(for: MusicGenre.self) { genre in
                GenreView(genre: genre)
            }
            .navigationDestination(for: String.self) { value in
                if value.hasPrefix("artist") {
                    let components = value.split(separator: "/")
                    
                    if components.count == 2 {
                        let id = components[1]
                        ArtistView(artistID: String(id))
                    }
                } else {
                    switch value {
                    case Routes.exploreSearch.rawValue:
                        ExploreSearchView()
                    case Routes.notifications.rawValue:
                        NotificationsView()
                    case Routes.homeAirport.rawValue:
                        AirportSearchView(airportCode: $homeAirport, title: "Home Airport")
                    case Routes.homeCity.rawValue:
                        CitySearchView(location: $homeCity, title: "Home City")
                    default:
                        EmptyView()
                    }
                }
            }
    }
}

extension View {
    func navigationDestinations(homeAirport: Binding<String>, homeCity: Binding<String>) -> some View {
        modifier(NavigationDestinationModifier(homeAirport: homeAirport, homeCity: homeCity))
    }
}

#Preview {
    ContentView()
        .environmentObject(Router())
        .environmentObject(AnimationManager())
}
