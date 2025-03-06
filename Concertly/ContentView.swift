import SwiftUI

struct ContentView: View {
    @AppStorage("Theme") private var theme: String = "Default"
    @AppStorage("Home Airport") private var homeAirport: String = "JFK"
    @AppStorage("Home City") private var homeCity: String = "New York, NY"
    
    @ObservedObject var exploreViewModel = ExploreViewModel()
    @ObservedObject var nearbyViewModel = NearbyViewModel()
    @ObservedObject var savedViewModel = SavedViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var animationManager: AnimationManager
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
            Group {
                NavigationStack(path: $router.explorePath) {
                    ExploreView(viewModel: exploreViewModel)
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
                            FullLineupView(lineup: lineup)
                        }
                        .navigationDestination(for: MusicGenre.self) { genre in
                            GenreView(genre: genre)
                        }
                        .navigationDestination(for: String.self) { value in
                            switch value {
                            case "exploreSearch":
                                ExploreSearchView()
                            case "Home Airport":
                                AirportSearchView(airportCode: $homeAirport, title: "Home Airport")
                            case "Home City":
                                CitySearchView(location: $homeCity, title: "Home City")
                            default:
                                Text(value)
                            }
                        }
                }
                .tabItem {
                    Label("Explore", systemImage: "globe.americas")
                }
                .tag(0)
                
                NavigationStack(path: $router.nearbyPath) {
                    NearbyView(viewModel: nearbyViewModel)
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
                            FullLineupView(lineup: lineup)
                        }
                        .navigationDestination(for: String.self) { value in
                            switch value {
                            case "exploreSearch":
                                ExploreSearchView()
                            case "Home Airport":
                                AirportSearchView(airportCode: $homeAirport, title: "Home Airport")
                            case "Home City":
                                CitySearchView(location: $homeCity, title: "Home City")
                            default:
                                Text(value)
                            }
                        }
                }
                .tabItem {
                    Label("Nearby", systemImage: "location")
                }
                .tag(1)
                
                NavigationStack(path: $router.savedPath) {
                    SavedView(viewModel: savedViewModel)
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
                            FullLineupView(lineup: lineup)
                        }
                        .navigationDestination(for: String.self) { value in
                            switch value {
                            case "exploreSearch":
                                ExploreSearchView()
                            case "Home Airport":
                                AirportSearchView(airportCode: $homeAirport, title: "Home Airport")
                            case "Home City":
                                CitySearchView(location: $homeCity, title: "Home City")
                            default:
                                Text(value)
                            }
                        }
                }
                .tabItem {
                    Label("Saved", systemImage: "bookmark.fill")
                }
                .tag(2)
                
                NavigationStack(path: $router.profilePath) {
                    ProfileView(profileViewModel: profileViewModel, nearbyViewModel: nearbyViewModel)
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
                            FullLineupView(lineup: lineup)
                        }
                        .navigationDestination(for: String.self) { value in
                            switch value {
                            case "exploreSearch":
                                ExploreSearchView()
                            case "Home Airport":
                                AirportSearchView(airportCode: $homeAirport, title: "Home Airport")
                            case "Home City":
                                CitySearchView(location: $homeCity, title: "Home City")
                            default:
                                Text(value)
                            }
                        }
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

#Preview {
    ContentView()
        .environmentObject(Router())
        .environmentObject(AnimationManager())
}
