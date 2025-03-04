import SwiftUI

@main
struct ConcertlyApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: CustomAppDelegate
    @State private var path = [String]()
    
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear(perform: {
                    appDelegate.app = self
                })
                .onOpenURL { url in
                    handleDeepLink(url)
                }
        }
    }
    
    private func handleDeepLink(_ url: URL) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        if let host = components?.host, host == "artist", let artistID = components?.queryItems?.first(where: { $0.name == "id" })?.value {
            path.append("artist:\(artistID)")
        }
    }
}
