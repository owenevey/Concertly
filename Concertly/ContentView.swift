import SwiftUI

struct ContentView: View {
        
    @AppStorage("Theme") private var theme: String = "Default"
    
    @ObservedObject var exploreViewModel: ExploreViewModel = ExploreViewModel()
    @ObservedObject var nearbyViewModel: NearbyViewModel = NearbyViewModel()
    @ObservedObject var savedViewModel: SavedViewModel = SavedViewModel()
    @ObservedObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    var body: some View {
        TabView {
            Group{
                NavigationStack {
                    ExploreView(viewModel: exploreViewModel)
                        .navigationDestination(for: String.self) { value in
                            if value.starts(with: "artist:") {
                                let artistID = value.replacingOccurrences(of: "artist:", with: "")
                                ArtistView(artistID: artistID)
                            }
                        }
                }
                .tabItem {
                    Label("Explore", systemImage: "globe.americas")
                }
                
                NavigationStack {
                    NearbyView(viewModel: nearbyViewModel)
                }
                .tabItem {
                    Label("Nearby", systemImage: "location")
                }
                
                NavigationStack {
                    SavedView(viewModel: savedViewModel)
                }
                .tabItem {
                    Label("Saved", systemImage: "bookmark.fill")
                }
                
                NavigationStack {
                    ProfileView(profileViewModel: profileViewModel, nearbyViewModel: nearbyViewModel)
                }
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            }
            .toolbarBackground(Color.background, for: .tabBar)
        }
        .preferredColorScheme(theme == "Light" ? .light : (theme == "Dark" ? .dark : nil))
    }
}

#Preview {
    ContentView()
}
