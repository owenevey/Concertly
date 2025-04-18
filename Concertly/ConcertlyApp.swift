import SwiftUI
import TipKit

@main
struct ConcertlyApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: CustomAppDelegate
    @StateObject var router = Router()
    @StateObject private var animationManager = AnimationManager()
    
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage(AppStorageKeys.minimumVersion.rawValue) var minimumVersion = "0.0.0"
    @State private var forceUpdateNeeded = false
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .disabled(forceUpdateNeeded)
                .overlay(
                    forceUpdateNeeded ? ForceUpdateView() : nil
                )
                .animation(.easeInOut(duration: 0.3), value: forceUpdateNeeded)
                .onAppear(perform: {
                    appDelegate.app = self
                })
                .onChange(of: scenePhase) { oldPhase, newPhase in
                    if newPhase == .active {
                        forceUpdateNeeded = isForceUpdateNeeded(minimumVersion: minimumVersion)
                        
                        Task {
                            if let fetchedVersion = try await fetchMinimumVersion() {
                                minimumVersion = fetchedVersion
                                forceUpdateNeeded = isForceUpdateNeeded(minimumVersion: minimumVersion)
                            }
                        }
                    }
                }
                .environmentObject(router)
                .environmentObject(animationManager)
                .onOpenURL { url in
                    router.handleOpenUrl(url: url)
                }
                .task {
                    try? Tips.configure([.displayFrequency(.daily),
                                         .datastoreLocation(.applicationDefault)])
                }
        }
    }
    
    private func isForceUpdateNeeded(minimumVersion: String) -> Bool {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }
        return currentVersion.compare(minimumVersion, options: .numeric) == .orderedAscending
    }
}

