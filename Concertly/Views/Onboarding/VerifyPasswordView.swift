import SwiftUI
import AWSCognitoIdentityProvider
import AuthenticationServices

struct VerifyPasswordView: View {
    
    var email: String
    
    @State var code: String = ""
    @State var newPassword: String = ""
    @State private var errorMessage: String? = nil
    @State var isLoading = false
    
    @State var navigateToSignIn = false
    
    @FocusState var isActive
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case code
        case newPassword
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
            
            VStack {
                BackButton()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 15) {
                    VStack(spacing: 5) {
                        Text("Enter your new password")
                            .font(.system(size: 23, type: .SemiBold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("We've sent a code to your email, please enter it below.")
                            .font(.system(size: 16, type: .Regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack {
                        Image(systemName: "number")
                            .fontWeight(.semibold)
                            .frame(width: 25)
                        TextField("Code", text: $code)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .submitLabel(.next)
                            .font(.system(size: 17, type: .Regular))
                            .padding(.trailing)
                            .focused($focusedField, equals: .code)
                            .onSubmit {
                                focusedField = .newPassword
                            }
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
                            .frame(width: 25)
                        TextField("New Password", text: $newPassword)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .submitLabel(.done)
                            .font(.system(size: 17, type: .Regular))
                            .padding(.trailing)
                            .focused($focusedField, equals: .newPassword)
                    }
                    .padding(15)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.gray1)
                            .frame(maxWidth: .infinity)
                    )
                    
                    Button { Task { await onTapSubmit() } } label: {
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
                            
                            Text("Submit")
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
                    
                    if let error = errorMessage {
                        ConcertlyButton(label: "Resend Code", style: .secondary) {
                            AuthenticationManager.shared.forgotPassword(email: email) { result in
                                DispatchQueue.main.async {
                                    
                                    switch result {
                                    case .success:
                                        withAnimation {
                                            errorMessage = nil
                                        }
                                    case .failure( _ as NSError):
                                        withAnimation {
                                            errorMessage = "Something went wrong. Please try again."
                                        }
                                    }
                                }
                            }
                        }
                        
                        Text(error)
                            .foregroundColor(.red)
                            .font(.system(size: 16, type: .Regular))
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .transition(.opacity)
                    }
                }
                .padding(.horizontal, 15)
                
                Spacer()
            }
        }
        .onAppear {
            isActive = true
        }
        .navigationDestination(isPresented: $navigateToSignIn) {
            SignInView()
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard)
    }
    
    private func onTapSubmit() async {
        errorMessage = nil
        
        if code.isEmpty {
            withAnimation {
                errorMessage = "Code is required."
            }
            return
        }
        
        if !isValidPassword(newPassword) {
            withAnimation {
                errorMessage = "Password must be at least 8 characters long, contain an uppercase and lowercase character, and a number."
            }
            return
        }
        
        AuthenticationManager.shared.confirmForgotPassword(email: email, confirmationCode: code, newPassword: newPassword) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    AuthenticationManager.shared.signIn(email: email, password: newPassword) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                Task {
                                    do {
                                        try await getUserData()
                                    } catch {
                                        navigateToSignIn = true
                                    }
                                }
                                UserDefaults.standard.set(true, forKey: AppStorageKeys.isSignedIn.rawValue)
                                
                            case .failure(_):
                                navigateToSignIn = true
                            }
                        }
                    }
                case .failure(let error as NSError):
                    withAnimation {
                        if error.domain == AWSCognitoIdentityProviderErrorDomain {
                            switch error.code {
                            case AWSCognitoIdentityProviderErrorType.codeMismatch.rawValue:
                                errorMessage = "The confirmation code is incorrect. Please double-check it."
                            case AWSCognitoIdentityProviderErrorType.expiredCode.rawValue:
                                errorMessage = "The confirmation code has expired. Please request a new code."
                            case AWSCognitoIdentityProviderErrorType.userNotFound.rawValue:
                                errorMessage = "User not found. Please verify your email or sign up."
                            case AWSCognitoIdentityProviderErrorType.limitExceeded.rawValue:
                                errorMessage = "Too many attempts. Please try again later."
                            default:
                                errorMessage = "Something went wrong. Please try again."
                            }
                        }
                        else {
                            errorMessage = "Something went wrong. Please try again."
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    VerifyPasswordView(email: "owenevey@gmail.com")
}
