import SwiftUI

struct AuthChoiceView: View {
    
    @AppStorage(AppStorageKeys.isSignedIn.rawValue) private var isSignedIn = false
    @AppStorage(AppStorageKeys.hasFinishedOnboarding.rawValue) private var hasFinishedOnboarding = false
    
    @State var errorMessage: String?
    
    @State private var navigateToLogin = false
    @State private var navigateToRegister = false
     
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            
            VStack(spacing: 15) {
                Spacer()
                
                Text("Concertly")
                    .font(.system(size: 50, type: .SemiBold))
                    .foregroundStyle(.accent)
                    .padding(.bottom, -15)
                
                Spacer()
                Spacer()
                
                
                ConcertlyButton(label: "Login", style: .primary) {
                    navigateToLogin = true
                }
                
                ConcertlyButton(label: "Register", style: .black) {
                    navigateToRegister = true
                }
            }
            .padding(30)
        }
        .navigationDestination(isPresented: $navigateToLogin) {
            EnterEmailView(isLogin: true)
        }
        .navigationDestination(isPresented: $navigateToRegister) {
            EnterEmailView(isLogin: false)
        }
        .navigationBarHidden(true)
        .disableSwipeBack(true)
    }
}

#Preview {
    NavigationStack {
        AuthChoiceView()
    }
}
