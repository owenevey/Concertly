import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "globe.europe.africa.fill")
                }
            
            Text("Events")
                .tabItem {
                    Label("Events", systemImage: "basketball")
                }
            Text("Trips")
                .tabItem {
                    Label("Trips", systemImage: "map")
                }.toolbarBackground(.green)
            
            Text("Profile")
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }.tint(.green)
    }
}

#Preview {
    ContentView()
}
