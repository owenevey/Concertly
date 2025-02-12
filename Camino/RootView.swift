import SwiftUI

struct RootView: View {
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                ContentView()
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else {
                LandingView()
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
        }
        .environmentObject(authViewModel)
        .animation(.easeInOut(duration: 0.3), value: authViewModel.isAuthenticated)
    }
}

#Preview {
    RootView()
}
