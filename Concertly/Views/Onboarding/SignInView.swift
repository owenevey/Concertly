import SwiftUI
import AWSCognitoIdentityProvider

struct SignInView: View {
    
    @AppStorage(AppStorageKeys.isSignedIn.rawValue) private var isSignedIn = false
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Now, type your password")
                .font(.system(size: 25, type: .SemiBold))
            
            TextField("Email", text: $email)
                .submitLabel(.done)
                .disableAutocorrection(true)
                .font(.system(size: 17, type: .Regular))
                .padding(.vertical, 15)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.gray3, lineWidth: 2)
                )
            
            TextField("Password", text: $password)
                .submitLabel(.done)
                .disableAutocorrection(true)
                .font(.system(size: 17, type: .Regular))
                .padding(.vertical, 15)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.gray3, lineWidth: 2)
                )
            
            ConcertlyButton(label: "Sign In", fitText: true) {
                AuthenticationService.shared.signIn(email: email, password: password) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let session):
                            isSignedIn = true
                            
                        case .failure(let error as NSError):
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
                        }
                    }
                }
            }
            .disabled(email.isEmpty || password.isEmpty)
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
        .padding(15)
        .navigationBarHidden(true)
    }
    
}

#Preview {
    NavigationStack {
        SignInView()
    }
}
