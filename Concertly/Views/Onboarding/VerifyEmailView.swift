import SwiftUI
import AWSCognitoIdentityProvider

struct VerifyEmailView: View {
    
    var email: String
    var password: String
    
    @State private var shouldNavigateToChooseCity = false
    
    @State var code: String = ""
    
    @State private var errorMessage: String? = nil
    @State private var showResendButton: Bool = false
    
    @AppStorage(AppStorageKeys.email.rawValue) private var emailStorage: String = ""
    
    var body: some View {
        VStack {
            Text("Enter the code sent to your email")
                .font(.system(size: 25, type: .SemiBold))
            
            TextField("Code", text: $code)
                .submitLabel(.done)
                .disableAutocorrection(true)
                .font(.system(size: 17, type: .Regular))
                .padding(.vertical, 15)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.gray3, lineWidth: 2)
                )
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 14, weight: .semibold))
            }
            
            if showResendButton {
                Button("Resend Code") {
                    AuthenticationService.shared.resendConfirmationCode(email: email) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                errorMessage = "Code resent. Check your email."
                                showResendButton = false
                            case .failure(let error):
                                errorMessage = "Couldn't resend code. Try again."
                                print("Resend error: \(error)")
                            }
                        }
                    }
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.blue)
            }
            
            ConcertlyButton(label: "Verify", fitText: true) {
                AuthenticationService.shared.confirmSignUp(email: email, password: password, confirmationCode: code) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            emailStorage = email
                            errorMessage = nil
                            showResendButton = false
                            Task {
                                try? await Task.sleep(for: .seconds(1))
                                shouldNavigateToChooseCity = true
                            }
                        case .failure(let error as NSError):
                            if error.domain == AWSCognitoIdentityProviderErrorDomain {
                                switch error.code {
                                case AWSCognitoIdentityProviderErrorType.codeMismatch.rawValue:
                                    errorMessage = "Invalid code. Try again or resend."
                                    showResendButton = true
                                case AWSCognitoIdentityProviderErrorType.expiredCode.rawValue:
                                    errorMessage = "Code expired. Tap below to resend."
                                    showResendButton = true
                                default:
                                    errorMessage = "Something went wrong. Try again."
                                    showResendButton = true
                                }
                            } else {
                                errorMessage = "Unknown error."
                            }
                        }
                    }
                }
            }
            .disabled(code.isEmpty)
        }
        .padding(15)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $shouldNavigateToChooseCity) {
            ChooseCityView()
        }
    }
}

#Preview {
    VerifyEmailView(email: "owenevey@gmail.com", password: "test123!")
}
