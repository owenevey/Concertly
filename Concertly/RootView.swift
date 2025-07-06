import SwiftUI

struct RootView: View {
    
    @AppStorage(AppStorageKeys.homeCity.rawValue) private var homeCity = ""
    @AppStorage(AppStorageKeys.homeAirport.rawValue) private var homeAirport = ""
    
    @AppStorage(AppStorageKeys.selectedNotificationPref.rawValue) private var selectedNotificationPref = false
    
    @AppStorage(AppStorageKeys.authStatus.rawValue) var authStatus: AuthStatus = .loggedOut
    
    @AppStorage(AppStorageKeys.startingScreen.rawValue) private var startingScreenRaw: String = RootScreen.landing.rawValue

    @StateObject var exploreViewModel = ExploreViewModel()
    @StateObject var nearbyViewModel = NearbyViewModel()
    @StateObject var savedViewModel = SavedViewModel()
    @StateObject var profileViewModel = ProfileViewModel()

    @State private var screen: RootScreen = RootScreen(rawValue: UserDefaults.standard.string(forKey: AppStorageKeys.startingScreen.rawValue) ?? RootScreen.landing.rawValue) ?? .landing

    var body: some View {
        ZStack {
            switch screen {
            case .landing:
                LandingView()
                    .transition(.slideInFromRight)
            case .authChoice:
                AuthChoiceView()
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
            if authStatus == .registered {
                Task { await fetchArtistImagesIfNeeded() }
            }
        }
        .onChange(of: authStatus) {
            updateScreen()
            if authStatus != .loggedOut {
                Task { await nearbyViewModel.getNearbyConcerts() }
            }
        }
        .onChange(of: homeCity) {
            updateScreen()
        }
        .onChange(of: homeAirport) {
            updateScreen()
        }
        .onChange(of: selectedNotificationPref) {
            updateScreen()
        }
    }

    private func updateScreen() {
        switch authStatus {
            case .loggedOut:
                screen = .landing

            case .guest:
                screen = selectedNotificationPref ? .content : .notificationSelection

            case .registered:
                screen = selectedNotificationPref ? .content : .notificationSelection
            }
        
        startingScreenRaw = screen.rawValue // Save it
    }
    
    func fetchArtistImagesIfNeeded() async {
        let now = Date()
        let oneWeek: TimeInterval = 7 * 24 * 60 * 60 // 7 days in seconds

        let lastRun = UserDefaults.standard.object(forKey: AppStorageKeys.lastCheckedImages.rawValue) as? Date ?? .distantPast

        if now.timeIntervalSince(lastRun) >= oneWeek {
            let followingArtists = CoreDataManager.shared.fetchItems(for: ContentCategories.following.rawValue, type: SuggestedArtist.self)
            
            for artist in followingArtists {
                do {
                    let imageResponse = try await fetchArtistImage(id: artist.id)
                    if let imageUrl = imageResponse.data {
                        CoreDataManager.shared.unSaveArtist(id: artist.id, category: ContentCategories.following.rawValue)
                        CoreDataManager.shared.saveArtist(SuggestedArtist(name: artist.name, id: artist.id, imageUrl: imageUrl), category: ContentCategories.following.rawValue)
                    } else {
                        throw NSError(domain: "Failed to fetch image", code: 0, userInfo: nil)
                    }
                } catch {
                    print("Failed to fetch image for artist \(artist.id): \(error)")
                }
            }
                        
            UserDefaults.standard.set(now, forKey: AppStorageKeys.lastCheckedImages.rawValue)
        }
    }
}

enum RootScreen: String {
    case landing
    case authChoice
    case notificationSelection
    case content
}

enum AuthStatus: String {
    case guest
    case registered
    case loggedOut
}


#Preview {
    RootView()
        .environmentObject(Router())
        .environmentObject(AnimationManager())
}
