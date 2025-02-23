import SwiftUI

struct RootView: View {
    
    @AppStorage("Has Seen Onboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        Group {
            if hasSeenOnboarding {
                ContentView()
            } else {
                LandingView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: hasSeenOnboarding)
    }
}

#Preview {
    RootView()
}
