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
            if isSignedIn {
                Task { await fetchArtistImagesIfNeeded() }
            }
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
    case chooseCity
    case notificationSelection
    case content
}


#Preview {
    RootView()
}
