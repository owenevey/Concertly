import SwiftUI

struct RootView: View {
    @AppStorage(AppStorageKeys.isSignedIn.rawValue) private var isSignedIn = false
    @AppStorage(AppStorageKeys.hasFinishedOnboarding.rawValue) private var hasFinishedOnboarding = false
    @AppStorage(AppStorageKeys.selectedNotificationPref.rawValue) private var selectedNotificationPref = false

    @AppStorage("startingScreen") private var startingScreenRaw: String = RootScreen.landing.rawValue

    @StateObject var exploreViewModel = ExploreViewModel()
    @StateObject var nearbyViewModel = NearbyViewModel()
    @StateObject var savedViewModel = SavedViewModel()
    @StateObject var profileViewModel = ProfileViewModel()

    @State private var screen: RootScreen = RootScreen(rawValue: UserDefaults.standard.string(forKey: "startingScreen") ?? RootScreen.landing.rawValue) ?? .landing

    var body: some View {
        ZStack {
            switch screen {
            case .landing:
                LandingView()
                    .transition(.slideInFromRight)
            case .chooseCity:
                NavigationStack {
                    ChooseCityView()
                }
                .transition(.slideInFromRight)
            case .notificationSelection:
                NotificationSelectionView()
                    .transition(.slideAndOpacity)
            case .content:
                ContentView(
                    exploreViewModel: exploreViewModel,
                    nearbyViewModel: nearbyViewModel,
                    savedViewModel: savedViewModel,
                    profileViewModel: profileViewModel
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: screen)
        .onAppear {
            updateScreen()
        }
        .onChange(of: isSignedIn) {
            updateScreen()
            if isSignedIn {
                Task { await exploreViewModel.getAllData() }
            }
        }
        .onChange(of: hasFinishedOnboarding) {
            updateScreen()
            if hasFinishedOnboarding {
                Task { await nearbyViewModel.getNearbyConcerts() }
            }
        }
        .onChange(of: selectedNotificationPref) { updateScreen() }
    }

    private func updateScreen() {
        if !isSignedIn {
            screen = .landing
        } else if !hasFinishedOnboarding {
            screen = .chooseCity
        } else if !selectedNotificationPref {
            screen = .notificationSelection
        } else {
            screen = .content
        }
        startingScreenRaw = screen.rawValue // Save it
    }
}

enum RootScreen: String {
    case landing
    case chooseCity
    case notificationSelection
    case content
}


#Preview {
    RootView()
}
