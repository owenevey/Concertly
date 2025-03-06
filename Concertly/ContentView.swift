import SwiftUI

struct ContentView: View {
    @AppStorage("Theme") private var theme: String = "Default"
    
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
                        .navigationDestination(for: SuggestedArtist.self) { artist in
                            ArtistView(artistID: artist.id)
                                .navigationTransition(.zoom(sourceID: artist.id, in: animationManager.animation))
                        }
                }
                .tabItem {
                    Label("Explore", systemImage: "globe.americas")
                }
                .tag(0)
                
                NavigationStack(path: $router.nearbyPath) {
                    NearbyView(viewModel: nearbyViewModel)
                }
                .tabItem {
                    Label("Nearby", systemImage: "location")
                }
                .tag(1)
                
                NavigationStack(path: $router.savedPath) {
                    SavedView(viewModel: savedViewModel)
                }
                .tabItem {
                    Label("Saved", systemImage: "bookmark.fill")
                }
                .tag(2)
                
                NavigationStack(path: $router.profilePath) {
                    ProfileView(profileViewModel: profileViewModel, nearbyViewModel: nearbyViewModel)
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
