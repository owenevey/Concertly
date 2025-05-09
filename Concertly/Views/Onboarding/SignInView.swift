import SwiftUI
import AWSCognitoIdentityProvider
import AuthenticationServices

struct SignInView: View {
    
    @AppStorage(AppStorageKeys.isSignedIn.rawValue) private var isSignedIn = false
    @AppStorage(AppStorageKeys.hasFinishedOnboarding.rawValue) private var hasFinishedOnboarding = false
    
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMessage: String?
    @State var isLoading = false
    
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailFormat).evaluate(with: email)
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Concertly")
                    .font(.system(size: 40, type: .SemiBold))
                    .foregroundStyle(.accent)
                    .padding(.bottom, 20)
                
                Text("Sign in to your account")
                    .font(.system(size: 23, type: .SemiBold))
                
                HStack {
                    Image(systemName: "envelope")
                        .fontWeight(.semibold)
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .submitLabel(.done)
                        .font(.system(size: 17, type: .Regular))
                        .padding(.trailing)
                }
                .padding(15)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray1)
                        .frame(maxWidth: .infinity)
                )
                
                VStack {
                    HStack {
                        Image(systemName: "lock")
                            .fontWeight(.semibold)
                        TextField("Password", text: $password)
                            .textContentType(.password)
                            .submitLabel(.done)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .font(.system(size: 17, type: .Regular))
                            .padding(.trailing)
                    }
                    .padding(15)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.gray1)
                            .frame(maxWidth: .infinity)
                    )
                    
                }
                
                Button { Task { await onTapSignIn() } } label: {
                    HStack {
                        HStack {
                            if isLoading {
                                CircleLoadingView(ringSize: 20, useWhite: true)
                            } else {
                                Color.clear
                            }
                            Spacer()
                        }
                        .padding(.leading, 15)
                        .frame(width: 90, height: isLoading ? nil : 1)
                        .transition(.opacity)
                        
                        Text("Sign In")
                            .font(.system(size: 17, type: .SemiBold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Color.clear
                            .padding(.trailing, 15)
                            .frame(width: 90, height: 1)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.accentColor)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: 15))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack {
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.system(size: 16, type: .Regular))
                            .multilineTextAlignment(.center)
                            .lineLimit(2, reservesSpace: true)
                            .padding(.top, 10)
                            .transition(.opacity)
                    }
                    
                    Text("Or")
                        .font(.system(size: 16, type: .Regular))
                        .foregroundStyle(.gray3)
                        .padding(.vertical, 15)
                    
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authorization):
                            handleSuccessfulLogin(with: authorization)
                        case .failure(let error):
                            handleLoginError(with: error)
                        }
                    }
                    .frame(height: 45)
                }
                .frame(height: 200)
                
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                    }
                }
                .font(.system(size: 16, type: .Medium))
                .frame(maxWidth: .infinity, alignment: .center)
                
            }
            .padding(30)
            .padding(.vertical, 30)
        }
        .navigationBarHidden(true)
        .disableSwipeBack(true)
    }
    
    func onTapSignIn() async {
        withAnimation {
            errorMessage = nil
        }
        
        if (!isValidEmail) {
            withAnimation {
                errorMessage = "Please enter a valid email."
            }
            return
        }
        
        if password.isEmpty {
            withAnimation {
                errorMessage = "Please enter a password."
            }
            return
        }
        
        withAnimation {
            isLoading = true
        }
        
        AuthenticationManager.shared.signIn(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    Task {
                        do {
                            try await getUserData()
                            DispatchQueue.main.async {
                                isSignedIn = true
                                withAnimation {
                                    isLoading = false
                                }
                            }
                        } catch {
                            DispatchQueue.main.async {
                                errorMessage = "Failed to load user. Please try again."
                                withAnimation {
                                    isLoading = false
                                }
                            }
                        }
                    }
                    
                case .failure(let error as NSError):
                    withAnimation {
                        if error.domain == AWSCognitoIdentityProviderErrorDomain {
                            switch error.code {
                            case AWSCognitoIdentityProviderErrorType.notAuthorized.rawValue:
                                errorMessage = "Incorrect credentials. Please check your email and password."
                            case AWSCognitoIdentityProviderErrorType.userNotFound.rawValue:
                                errorMessage = "User not found. Please check your email or sign up."
                            case AWSCognitoIdentityProviderErrorType.invalidParameter.rawValue:
                                errorMessage = "Invalid input. Double-check your info."
                            case AWSCognitoIdentityProviderErrorType.passwordResetRequired.rawValue:
                                errorMessage = "Password reset required. Follow the instructions to reset your password."
                            case AWSCognitoIdentityProviderErrorType.tooManyRequests.rawValue:
                                errorMessage = "Too many requests. Please try again later."
                            case AWSCognitoIdentityProviderErrorType.expiredCode.rawValue:
                                errorMessage = "Session expired. Please sign in again."
                            default:
                                errorMessage = "Something went wrong. Please try again."
                            }
                        } else {
                            errorMessage = "Something went wrong. Please try again."
                        }
                        isLoading = false
                    }
                }
            }
        }
    }
    
    func getUserData() async throws {
        let response = try await fetchUserPreferences()
        if let preferences = response.data {
            if let city = preferences.city {
                UserDefaults.standard.set(preferences.city, forKey: AppStorageKeys.homeCity.rawValue)
                UserDefaults.standard.set(preferences.latitude, forKey: AppStorageKeys.homeLat.rawValue)
                UserDefaults.standard.set(preferences.longitude, forKey: AppStorageKeys.homeLong.rawValue)
                UserDefaults.standard.set(preferences.airport, forKey: AppStorageKeys.homeAirport.rawValue)
            } else {
                // They haven't saved preferences
                return
            }
        } else {
            throw NSError(domain: "getUserData preferences failed", code: 1, userInfo: nil)
        }
        
        let artistsResponse = try await fetchFollowedArtists()
        
        if let artistsData = artistsResponse.data {
            if artistsData.count > 0 {
                CoreDataManager.shared.saveItems(artistsData, category: ContentCategories.following.rawValue)
            }
        } else {
            throw NSError(domain: "getUserData preferences failed", code: 1, userInfo: nil)
        }
        
        UserDefaults.standard.set(true, forKey: AppStorageKeys.hasFinishedOnboarding.rawValue)
    }
    
    
    private func handleSuccessfulLogin(with authorization: ASAuthorization) {
        if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print(userCredential.user)
            
            if userCredential.authorizedScopes.contains(.fullName) {
                print(userCredential.fullName?.givenName ?? "No given name")
            }
            
            if userCredential.authorizedScopes.contains(.email) {
                print(userCredential.email ?? "No email")
            }
        }
    }
    
    private func handleLoginError(with error: Error) {
        print("Could not authenticate: \\(error.localizedDescription)")
    }
}

#Preview {
    SignInView()
}
