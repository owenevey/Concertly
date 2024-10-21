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
                    TripsView()
                }
                .tabItem {
                    Label("Trips", systemImage: "map")
                }
                
                NavigationStack {
                    ProfileView()
                }
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            }
            .toolbarBackground(Color("Background"), for: .tabBar)
        }
    }
}

#Preview {
    ContentView()
}
