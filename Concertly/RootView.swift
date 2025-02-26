import SwiftUI

struct RootView: View {
    
    @AppStorage("Has Seen Onboarding") private var hasSeenOnboarding: Bool = false
    
    @StateObject var exploreViewModel: ExploreViewModel = ExploreViewModel()
    @StateObject var nearbyViewModel: NearbyViewModel = NearbyViewModel()
    @StateObject var savedViewModel: SavedViewModel = SavedViewModel()
    @StateObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    var body: some View {
        Group {
            if hasSeenOnboarding {
                ContentView(exploreViewModel: exploreViewModel, nearbyViewModel: nearbyViewModel, savedViewModel: savedViewModel, profileViewModel: profileViewModel)
            } else {
                LandingView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: hasSeenOnboarding)
    }
}

#Preview {
    RootView()
}
