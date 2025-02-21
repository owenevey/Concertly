import SwiftUI

struct ContentView: View {
    
    @AppStorage("Theme") private var theme: String = "Default"
    
    @StateObject var exploreViewModel: ExploreViewModel = ExploreViewModel()
    @StateObject var nearbyViewModel: NearbyViewModel = NearbyViewModel()
    @StateObject var savedViewModel: SavedViewModel = SavedViewModel()
    @StateObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    var body: some View {
        TabView {
            Group{
                NavigationStack {
                    ExploreView(viewModel: exploreViewModel)
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
