import SwiftUI
import AWSCognitoIdentityProvider
import AuthenticationServices

struct ForgotPasswordView: View {
    
    @State var email: String = ""
    @State var submittedEmail = ""
    @State private var errorMessage: String? = nil
    @State var isLoading = false
    
    @State private var navigateToVerify = false
    
    @FocusState var isFocused
    
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailFormat).evaluate(with: email)
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
                        Text("Forgot Password")
                            .font(.system(size: 23, type: .SemiBold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Enter your email address")
                            .font(.system(size: 16, type: .Regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack {
                        Image(systemName: "envelope")
                            .fontWeight(.semibold)
                            .frame(width: 25)
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                            .submitLabel(.return)
                            .font(.system(size: 17, type: .Regular))
                            .padding(.trailing)
                            .focused($isFocused)
                            .onSubmit {
                                Task {
                                    await onTapSubmit()
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
                    .disabled(isLoading)
                    
                    Text(errorMessage ?? "")
                        .foregroundColor(.red)
                        .font(.system(size: 16, type: .Regular))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.top, 10)
                        .transition(.opacity)
                }
                .padding(.horizontal, 15)
                
                Spacer()
            }
        }
        .onAppear {
            isFocused = true
        }
        .navigationDestination(isPresented: $navigateToVerify) {
            VerifyPasswordView(email: submittedEmail)
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard)
    }
    
    private func onTapSubmit() async {
        withAnimation {
            errorMessage = nil
        }
        
        if (!isValidEmail) {
            withAnimation {
                errorMessage = "Please enter a valid email."
            }
            return
        }
        
        submittedEmail = email
        
        withAnimation {
            isLoading = true
        }
        
        AuthenticationManager.shared.forgotPassword(email: email) { result in
            DispatchQueue.main.async {
                withAnimation {
                    isLoading = false
                }
                
                switch result {
                case .success:
                    navigateToVerify = true
                case .failure(let error as NSError):
                    withAnimation {
                        if error.domain == AWSCognitoIdentityProviderErrorDomain {
                            switch error.code {
                            case AWSCognitoIdentityProviderErrorType.userNotFound.rawValue:
                                errorMessage = "No user found with given email."
                            case AWSCognitoIdentityProviderErrorType.invalidParameter.rawValue:
                                errorMessage = "Invalid input. Double-check your info."
                            case AWSCognitoIdentityProviderErrorType.tooManyRequests.rawValue:
                                errorMessage = "Too many requests. Please try again later."
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
    }
}

#Preview {
    ForgotPasswordView()
}
