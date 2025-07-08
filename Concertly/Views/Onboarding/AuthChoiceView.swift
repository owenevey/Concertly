import SwiftUI

struct AuthChoiceView: View {
    
    @AppStorage(AppStorageKeys.authStatus.rawValue) var authStatus: AuthStatus = .loggedOut
        
    @State private var navigateToLogin = false
    @State private var navigateToRegister = false
     
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 90))
                    .padding(.bottom, -10)
                    .foregroundStyle(.accent)
                
                Text("Make it personal")
                    .font(.system(size: 30, type: .SemiBold))
                    .foregroundStyle(.accent)
                
                Text("Create an account to follow artists, get personalized suggestions, and be the first to know about new tour dates.")
                    .font(.system(size: 17, type: .Regular))
                    .padding(.horizontal, 30)
                    .multilineTextAlignment(.center)
                
                Spacer()
                Spacer()
                
                
                VStack(spacing: 15) {
                    ConcertlyButton(label: "Register", style: .primary) {
                        navigateToRegister = true
                        clearOnlyAuthData()
                    }
                    
                    ConcertlyButton(label: "Login", style: .black) {
                        navigateToLogin = true
                        clearOnlyAuthData()
                    }
                    
                    Button {
                        authStatus = .guest
                        clearOnlyAuthData()
                    } label: {
                        Text("No thanks")
                            .font(.system(size: 17, type: .Regular))
                            .foregroundStyle(.gray3)
                    }
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
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    NavigationStack {
        AuthChoiceView()
    }
}
