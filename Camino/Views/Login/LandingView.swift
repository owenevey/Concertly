import SwiftUI
import AuthenticationServices

struct LandingView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Text("Camino")
                    .font(.system(size: 40, type: .SemiBold))
                    .foregroundStyle(.accent)
                
                VStack {
                        HStack {
//                            Image(systemName: "envelope")
//                                .font(.system(size: 15))
//                                .fontWeight(.semibold)
//                                .frame(width: 15)
                            
                            TextField("Email", text: $authViewModel.username)
                                .autocapitalization(.none)
                                .font(.system(size: 18, type: .Regular))
                                .padding(.trailing)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.gray1)
                                .frame(maxWidth: .infinity)
                        )
                    
                    HStack {
//                        Image(systemName: "lock")
//                            .font(.system(size: 15))
//                            .fontWeight(.semibold)
//                            .frame(width: 15)
//                            .
                        TextField("Password", text: $authViewModel.password)
                            .autocapitalization(.none)
                            .font(.system(size: 18, type: .Regular))
                            .padding(.trailing)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.gray1)
                            .frame(maxWidth: .infinity)
                    )
                    
                    
                    CaminoButton(label: "Sign In") {
                        authViewModel.login()
                    }
                    
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .overlay(.gray2)
                        
                        Text("or")
                            .font(.system(size: 18, type: .Regular))
                            .foregroundStyle(.gray3)
                            .padding(.vertical, 15)
                        
                        Rectangle()
                            .frame(height: 1)
                            .overlay(.gray2)
                    }
                    
                    SignInWithAppleButton(.signIn) { request in
                                // Configure the request here
                            } onCompletion: { result in
                                // Handle the authentication result here
                            }
                            .signInWithAppleButtonStyle(.black) // Other options: .white, .whiteOutline
                            .frame(width: 200, height: 40)
                            .cornerRadius(8)
                    
                    HStack {
                        Text("Don't have an account?")
                        
                        Text("Sign Up")
                            .foregroundStyle(.accent)
                            .underline()
                    }
                    .font(.system(size: 18, type: .Regular))
                    .padding(.top, 20)
                }
                .frame(width: UIScreen.main.bounds.width - 40)
                Spacer()
                
                Text("Skip")
                    .font(.system(size: 18, type: .Regular))
                    .foregroundStyle(.gray3)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
            }
            .ignoresSafeArea(edges: .all)
            .frame(maxWidth: .infinity)
            .background(Color.background)
        }
    }
}

#Preview {
    RootView()
}
