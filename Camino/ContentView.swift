import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Group{
                NavigationStack {
                    ExploreView()
                }
                .tabItem {
                    Label("Explore", systemImage: "globe.americas")
                }
                
                NavigationStack {
                    NearbyView()
                }
                .tabItem {
                    Label("Nearby", systemImage: "location")
                }
                
                NavigationStack {
                    SavedView()
                }
                .tabItem {
                    Label("Saved", systemImage: "bookmark.fill")
                }
                
                NavigationStack {
                    ProfileView()
                }
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            }
            .toolbarBackground(Color.background, for: .tabBar)
        }
    }
}

#Preview {
    ContentView()
}
