import SwiftUI

struct RootView: View {
    
    @AppStorage(AppStorageKeys.isSignedIn.rawValue) private var isSignedIn = false
    @AppStorage(AppStorageKeys.hasFinishedOnboarding.rawValue) private var hasFinishedOnboarding = false
    @AppStorage(AppStorageKeys.selectedNotificationPref.rawValue) private var selectedNotificationPref = false
    
    @StateObject var exploreViewModel: ExploreViewModel = ExploreViewModel()
    @StateObject var nearbyViewModel: NearbyViewModel = NearbyViewModel()
    @StateObject var savedViewModel: SavedViewModel = SavedViewModel()
    @StateObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    var body: some View {
        Group {
            if isSignedIn {
                if hasFinishedOnboarding {
                    if selectedNotificationPref {
                        ContentView(exploreViewModel: exploreViewModel, nearbyViewModel: nearbyViewModel, savedViewModel: savedViewModel, profileViewModel: profileViewModel)
                    }
                    else {
                        NotificationSelectionView()
                    }
                } else {
                    NavigationStack {
                        ChooseCityView()
                    }
                }
            } else {
                LandingView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isSignedIn || hasFinishedOnboarding || selectedNotificationPref)
    }
}

#Preview {
    RootView()
}
