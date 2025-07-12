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
    @State private var isOutage = false
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .disabled(forceUpdateNeeded || isOutage)
                .overlay(
                        Group {
                            if forceUpdateNeeded {
                                ForceUpdateView()
                                    .transition(.opacity)
                            } else if isOutage {
                                OutageView()
                                    .transition(.opacity)
                            }
                        }
                    )
                    .animation(.easeInOut(duration: 0.3), value: forceUpdateNeeded || isOutage)
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
                            
                            if let outage = try await fetchOutage() {
                                isOutage = outage
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
                    try? Tips.configure([.displayFrequency(.weekly),
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

