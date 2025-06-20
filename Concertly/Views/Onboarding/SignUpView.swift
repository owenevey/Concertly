import SwiftUI
import AWSCognitoIdentityProvider
import AuthenticationServices

struct SignUpView: View {
    
    @State var email: String = ""
    @State var password1: String = ""
    @State var password2: String = ""
    @State var errorMessage: String?
    @State var isLoading = false
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email
        case password1
        case password2
    }
    
    @State private var navigateToVerify = false
    
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailFormat).evaluate(with: email)
    }
    
    var isValidPassword: Bool {
        let minLengthRule = password2.count >= 8
        let uppercaseRule = password2.range(of: "[A-Z]", options: .regularExpression) != nil
        let lowercaseRule = password2.range(of: "[a-z]", options: .regularExpression) != nil
        let numberRule = password2.range(of: "[0-9]", options: .regularExpression) != nil
        
        return minLengthRule && uppercaseRule && lowercaseRule && numberRule
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                Text("Create your account")
                    .font(.system(size: 27, type: .SemiBold))
                    .padding(.vertical, 15)
                
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
                            focusedField = .password1
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
                    SecureField("Password", text: $password1)
                        .textContentType(.newPassword)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .submitLabel(.next)
                        .font(.system(size: 17, type: .Regular))
                        .padding(.trailing)
                        .focused($focusedField, equals: .password1)
                        .onSubmit {
                            focusedField = .password2
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
                    focusedField = .password1
                }
                
                HStack {
                    Image(systemName: "lock")
                        .fontWeight(.semibold)
                        .frame(width: 25)
                    SecureField("Confirm Password", text: $password2)
                        .textContentType(.newPassword)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .submitLabel(.done)
                        .font(.system(size: 17, type: .Regular))
                        .padding(.trailing)
                        .focused($focusedField, equals: .password2)
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
                    focusedField = .password2
                }
                
                
                
                Button { Task { await onTapSignUp() } } label: {
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
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.system(size: 16, type: .Regular))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.top, 10)
                        .transition(.opacity)
                }
                
                Spacer()
                
                HStack {
                    Text("Have an account?")
                    Button("Sign In") {
                        dismiss()
                    }
                }
                .font(.system(size: 16, type: .Medium))
                .frame(maxWidth: .infinity, alignment: .center)
                
            }
            .padding(30)
        }
        .onTapGesture {
            focusedField = nil
        }
        .navigationBarHidden(true)
        .disableSwipeBack(true)
        .navigationDestination(isPresented: $navigateToVerify) {
            CodeInputView(email: email.lowercased(), password: password1)
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func onTapSignUp() async {
        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
        
        if !isValidPassword {
            withAnimation {
                errorMessage = "Password must be at least 8 characters long, contain an uppercase and lowercase character, and a number."
            }
            return
        }
        
        withAnimation {
            isLoading = true
        }
        
        AuthenticationManager.shared.signUp(email: email.lowercased(), password: password1) { result in
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
    SignUpView()
}
