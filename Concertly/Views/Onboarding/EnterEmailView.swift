import SwiftUI
import AWSCognitoIdentityProvider
import AuthenticationServices

struct EnterEmailView: View {
    
    let isLogin: Bool
    
    @State var email: String = ""
    @State private var errorMessage: String? = nil
    @State var isLoading = false
    
    @State private var navigateToPasswordView = false
    
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
                    Text("Enter your email address")
                        .font(.system(size: 23, type: .SemiBold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
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
                                onSubmit()
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
                    
                    ConcertlyButton(label: "Next", style: .primary) {
                        onSubmit()
                    }
                    
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
        .navigationDestination(isPresented: $navigateToPasswordView) {
            EnterPasswordView(email: email, isLogin: isLogin)
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard)
    }
    
    private func onSubmit() {
        withAnimation {
            errorMessage = nil
        }
        
        email = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if (!isValidEmail) {
            withAnimation {
                errorMessage = "Please enter a valid email."
            }
            return
        }
        
        navigateToPasswordView = true
    }
}
#Preview {
    EnterEmailView(isLogin: true)
}
