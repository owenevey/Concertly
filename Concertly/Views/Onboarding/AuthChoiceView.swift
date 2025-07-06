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
                
                Image(.kanyeOnPhone)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 300)
                    .cornerRadius(20)
                    .clipped()
                    .padding(.bottom, 10)
                
                Text("Make it personal.")
                    .font(.system(size: 25, type: .SemiBold))
                
                Text("Create an account to follow artists, get personalized suggestions, and be the first to know about new tour dates.")
                    .font(.system(size: 17, type: .Regular))
                    .padding(.horizontal, 30)
                    .multilineTextAlignment(.center)
                
                Spacer()
                Spacer()
                
                
                VStack(spacing: 15) {
                    ConcertlyButton(label: "Login", style: .primary) {
                        navigateToLogin = true
                        clearOnlyAuthData()
                    }
                    
                    
                    ConcertlyButton(label: "Register", style: .black) {
                        navigateToRegister = true
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
