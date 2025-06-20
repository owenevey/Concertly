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
    
    @State private var navigateToSignUp = false
    @State private var navigateToVerify = false
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email
        case password
    }
    
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailFormat).evaluate(with: email)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                
                VStack(spacing: 15) {
                    Spacer()
                    
                    Text("Concertly")
                        .font(.system(size: 50, type: .SemiBold))
                        .foregroundStyle(.accent)
                        .padding(.bottom, -15)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    HStack {
                        Image(systemName: "envelope")
                            .fontWeight(.semibold)
                            .frame(width: 25)
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                            .submitLabel(.next)
                            .font(.system(size: 17, type: .Regular))
                            .padding(.trailing)
                            .focused($focusedField, equals: .email)
                            .onSubmit {
                                focusedField = .password
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
                        focusedField = .email
                    }
                    
                    HStack {
                        Image(systemName: "lock")
                            .fontWeight(.semibold)
                            .frame(width: 25)
                        SecureField("Password", text: $password)
                            .textContentType(.password)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .submitLabel(.done)
                            .font(.system(size: 17, type: .Regular))
                            .padding(.trailing)
                            .focused($focusedField, equals: .password)
                            .onSubmit {
                                focusedField = nil
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
                        focusedField = .password
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
                    .disabled(isLoading)
                    
                    HStack {
                        Spacer()
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot Password?")
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                        }
                        Spacer()
                    }
                    .font(.system(size: 16, type: .Medium))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
                }
                .padding(30)
            }
        }
        .safeAreaInset(edge: .bottom) {
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.system(size: 16, type: .Regular))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 5)
                    .background(Color.background)
                    .transition(.opacity)
            }
        }
        .onTapGesture {
            focusedField = nil
        }
        .onAppear {
            errorMessage = nil
        }
        .navigationBarHidden(true)
        .disableSwipeBack(true)
        .navigationDestination(isPresented: $navigateToVerify) {
            CodeInputView(email: email.lowercased(), password: password)
        }
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
                            case AWSCognitoIdentityProviderErrorType.userNotConfirmed.rawValue:
                                navigateToVerify = true
                                AuthenticationManager.shared.resendConfirmationCode(email: email) { result in
                                    
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
}

#Preview {
    NavigationStack {
        SignInView()
    }
}
