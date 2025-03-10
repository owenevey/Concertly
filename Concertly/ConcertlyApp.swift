import SwiftUI
import TipKit

@main
struct ConcertlyApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: CustomAppDelegate
    @StateObject var router = Router()
    @StateObject private var animationManager = AnimationManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear(perform: {
                    appDelegate.app = self
                })
                .environmentObject(router)
                .environmentObject(animationManager)
                .onOpenURL { url in
                    router.handleOpenUrl(url: url)
                }
                .task {
                    try? Tips.configure([.displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)])
                }
        }
    }
}

