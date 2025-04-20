import SwiftUI
import AWSCognitoIdentityProvider

struct EnterPasswordView: View {
    
    let email: String
    
    @State private var shouldNavigateToVerify = false
    
    @State var password1: String = ""
    @State var password2: String = ""
    
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Now, type your password")
                .font(.system(size: 25, type: .SemiBold))
            
            TextField("Password", text: $password1)
                .submitLabel(.done)
                .disableAutocorrection(true)
                .font(.system(size: 17, type: .Regular))
                .padding(.vertical, 15)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.gray3, lineWidth: 2)
                )
            
            TextField("Confirm Password", text: $password2)
                .submitLabel(.done)
                .disableAutocorrection(true)
                .font(.system(size: 17, type: .Regular))
                .padding(.vertical, 15)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.gray3, lineWidth: 2)
                )
            
            ConcertlyButton(label: "Next", fitText: true) {
                AuthenticationService.shared.signUp(email: email, password: password1) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            shouldNavigateToVerify = true
                        case .failure(let error as NSError):
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
                }
            }
            .disabled(password1 != password2 || password1.isEmpty)
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
        .padding(15)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $shouldNavigateToVerify) {
            VerifyEmailView(email: email, password: password1)
        }
    }
    
}

#Preview {
    NavigationStack {
        EnterPasswordView(email: "owenevey@gmail.com")
    }
}
