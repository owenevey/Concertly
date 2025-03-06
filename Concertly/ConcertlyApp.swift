import SwiftUI

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
        }
    }
}


class AnimationManager: ObservableObject {
    let animation: Namespace.ID = Namespace().wrappedValue
}
