import SwiftUI

@main
struct ConcertlyApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: CustomAppDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear(perform: {
                    appDelegate.app = self
                })
        }
    }
}
