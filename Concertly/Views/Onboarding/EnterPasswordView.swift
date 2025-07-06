import SwiftUI
import AWSCognitoIdentityProvider
import AuthenticationServices

struct EnterPasswordView: View {
    
    let email: String
    let isLogin: Bool
    
    @AppStorage(AppStorageKeys.authStatus.rawValue) var authStatus: AuthStatus = .loggedOut
    
    @State var password: String = ""
    @State private var errorMessage: String? = nil
    @State var isLoading = false
    
    @State private var navigateToRegisterCodeView = false
    @State private var navigateToChooseArtistsView = false
    
    @FocusState var isFocused
    
    var isValidPassword: Bool {
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
                    Text(isLogin ? "Enter your password" : "Create a password")
                        .font(.system(size: 23, type: .SemiBold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Image(systemName: "lock")
                            .fontWeight(.semibold)
                            .frame(width: 25)
                        TextField("Password", text: $password)
                            .textContentType(.password)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                            .submitLabel(.return)
                            .font(.system(size: 17, type: .Regular))
                            .padding(.trailing)
                            .focused($isFocused)
                            .onSubmit {
                                Task {
                                    await onSubmit()
                                }
                            }
                    }
                    .padding(15)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.gray1)
                            .frame(maxWidth: .infinity)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray2, lineWidth: 1)
                    )
                    .onTapGesture {
                        isFocused = true
                    }
                    
                    Button {
                        Task {
                            await onSubmit()
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
                            
                            Text(isLogin ? "Login" : "Register")
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
                    .disabled(isLoading)
                    
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot Password?")
                    }
                    .font(.system(size: 16, type: .Medium))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
                    
                    Text(errorMessage ?? "")
                        .foregroundColor(.red)
                        .font(.system(size: 16, type: .Regular))
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .lineLimit(nil)
                        .transition(.opacity)
                }
                .padding(.horizontal, 15)
                
                Spacer()
            }
        }
        .onAppear {
            isFocused = true
        }
        .navigationDestination(isPresented: $navigateToRegisterCodeView) {
            RegisterCodeView(email: email, password: password)
        }
        .navigationDestination(isPresented: $navigateToChooseArtistsView) {
            ChooseArtistsView()
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard)
    }
    
    func onSubmit() async {
        withAnimation {
            errorMessage = nil
        }
        
        if (!isValidPassword) {
            withAnimation {
                errorMessage = "Password must be at least 8 characters, contain uppercase letter, lowercase letter, and a number."
            }
            return
        }
        
        withAnimation {
            isLoading = true
        }
        
        if isLogin {
            await onTapLogin()
        } else {
            await onTapRegister()
        }
    }
    
    func onTapLogin() async {
        AuthenticationManager.shared.signIn(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    Task {
                        do {
                            let hasSavedPrefs = try await getUserData()
                            
                            DispatchQueue.main.async {
                                withAnimation {
                                    isLoading = false
                                }
                            }
                            
                            if hasSavedPrefs {
                                authStatus = .registered
                            } else {
                                navigateToChooseArtistsView = true
                            }
                            
                        } catch {
                            DispatchQueue.main.async {
                                withAnimation {
                                    isLoading = false
                                }
                                errorMessage = "Failed to load user. Please try again."
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
                            case AWSCognitoIdentityProviderErrorType.userNotConfirmed.rawValue:
                                isLoading = false
                                navigateToRegisterCodeView = true
                                AuthenticationManager.shared.resendConfirmationCode(email: email) { _ in
                                }
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
    
    func onTapRegister() async {
        AuthenticationManager.shared.signUp(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    navigateToRegisterCodeView = true
                case .failure(let error as NSError):
                    withAnimation {
                        if error.domain == AWSCognitoIdentityProviderErrorDomain {
                            switch error.code {
                            case AWSCognitoIdentityProviderErrorType.usernameExists.rawValue:
                                errorMessage = "That email is already registered. Please sign in."
                            case AWSCognitoIdentityProviderErrorType.invalidPassword.rawValue:
                                errorMessage = "Password must be at least 8 characters, contain uppercase letter, lowercase letter, and a number."
                            case AWSCognitoIdentityProviderErrorType.invalidParameter.rawValue:
                                errorMessage = "Invalid input. Double-check your info."
                            case AWSCognitoIdentityProviderErrorType.limitExceeded.rawValue:
                                errorMessage = "Too many attempts. Please wait a moment and try again."
                            case AWSCognitoIdentityProviderErrorType.codeDeliveryFailure.rawValue:
                                errorMessage = "Failed to send verification code. Please check your email and try again."
                            default:
                                errorMessage = "Something went wrong. Try again."
                            }
                        } else {
                            errorMessage = "Something went wrong. Try again."
                        }
                    }
                }
                withAnimation {
                    isLoading = false
                }
            }
        }
    }
}



#Preview {
    NavigationStack {
        EnterPasswordView(email: "owenevey@gmail.com", isLogin: true)
    }
}
