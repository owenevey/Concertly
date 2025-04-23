import SwiftUI
import AWSCognitoIdentityProvider
import AuthenticationServices

struct SignUpView: View {
        
    @State var email: String = ""
    @State var password1: String = ""
    @State var password2: String = ""
    @State var errorMessage: String?
    @State var isLoading = false
    
    @State private var navigateToVerify = false
    
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailFormat).evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let minLengthRule = password.count >= 8
        let uppercaseRule = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let lowercaseRule = password.range(of: "[a-z]", options: .regularExpression) != nil
        let numberRule = password.range(of: "[0-9]", options: .regularExpression) != nil

        return minLengthRule && uppercaseRule && lowercaseRule && numberRule
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
                
                Text("Create your account")
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
                
                HStack {
                    Image(systemName: "lock")
                        .fontWeight(.semibold)
                    TextField("Password", text: $password1)
                        .textContentType(.newPassword)
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
                
                VStack {
                    HStack {
                        Image(systemName: "lock")
                            .fontWeight(.semibold)
                        TextField("Confirm Password", text: $password2)
                            .textContentType(.newPassword)
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
                    
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.system(size: 16, type: .Regular))
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .padding(.top, 10)
                            .transition(.opacity)
                    }
                }
                
                
                Button {
                    withAnimation {
                        errorMessage = nil
                    }
                    
                    if (!isValidEmail) {
                        withAnimation {
                            errorMessage = "Please enter a valid email."
                        }
                        return
                    }
                    
                    if password1.isEmpty {
                        withAnimation {
                            errorMessage = "Please enter a password."
                        }
                        return
                    }
                    
                    if password1 != password2 {
                        withAnimation {
                            errorMessage = "Passwords do not match."
                        }
                        return
                    }
                    
                    if !isValidPassword(password1) {
                        withAnimation {
                            errorMessage = "Password must be at least 8 characters long, contain an uppercase and lowercase character, and a number."
                        }
                        return
                    }
                    
                    withAnimation {
                        isLoading = true
                    }
                    
                    AuthenticationService.shared.signUp(email: email, password: password1) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                navigateToVerify = true
                            case .failure(let error as NSError):
                                withAnimation {
                                    if error.domain == AWSCognitoIdentityProviderErrorDomain {
                                        switch error.code {
                                        case AWSCognitoIdentityProviderErrorType.usernameExists.rawValue:
                                            errorMessage = "That email is already registered. Please sign in."
                                        case AWSCognitoIdentityProviderErrorType.invalidPassword.rawValue:
                                            errorMessage = "Password must be at least 8 characters, contain uppercase and lowercase, number, and symbol."
                                        case AWSCognitoIdentityProviderErrorType.invalidParameter.rawValue:
                                            errorMessage = "Invalid input. Double-check your info."
                                        default:
                                            errorMessage = "Something went wrong. Try again."
                                        }
                                    } else {
                                        errorMessage = "Something went wrong. Try again."
                                    }
                                }
                            }
                            isLoading = false
                        }
                    }
                } label: {
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
                        
                        Text("Sign Up")
                            .font(.system(size: 17, type: .SemiBold))
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
                
                Text("Or")
                    .font(.system(size: 16, type: .Regular))
                    .foregroundStyle(.gray3)
                    .padding(.vertical, 15)
                
                SignInWithAppleButton(.signUp) { request in
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
                
                Spacer()
                
                HStack {
                    Text("Have an account?")
                    NavigationLink(destination: SignInView()) {
                        Text("Sign In")
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
        .navigationDestination(isPresented: $navigateToVerify) {
            VerifyEmailView(email: email, password: password1)
        }
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
    SignUpView()
}
