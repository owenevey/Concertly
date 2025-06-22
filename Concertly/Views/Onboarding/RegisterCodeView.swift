import SwiftUI
import AWSCognitoIdentityProvider

struct RegisterCodeView: View {
    
    var email: String
    var password: String
    
    @State private var infoMessage: String? = nil
    @State private var showResendButton: Bool = false
    @State private var showGoToSignIn: Bool = false
    
    @State var value: String = ""
    @State var state: TypingState = .typing
    @FocusState var isFocused
        
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                BackButton()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 15) {
                    Text("Enter the code sent to your email")
                        .font(.system(size: 23, type: .SemiBold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        ForEach(0..<6, id: \.self) { index in
                            CharacterView(index)
                        }
                    }
                    .padding(.bottom, 15)
                    .compositingGroup()
                    .background {
                        TextField("", text: $value)
                            .focused($isFocused)
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                            .mask(alignment: .trailing) {
                                Rectangle()
                                    .frame(width: 1, height: 1)
                                    .opacity(0.01)
                            }
                            .allowsHitTesting(false)
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        isFocused = true
                    }
                    .onChange(of: value) { oldValue, newValue in
                        value = String(newValue.prefix(6))
                        if value.count == 6 {
                            Task { @MainActor in
                                AuthenticationManager.shared.confirmSignUp(email: email, confirmationCode: value) { result in
                                    DispatchQueue.main.async {
                                        switch result {
                                        case .success:
                                            withAnimation {
                                                state = .valid
                                            }
                                            AuthenticationManager.shared.signIn(email: email, password: password) { result in
                                                DispatchQueue.main.async {
                                                    switch result {
                                                    case .success:
                                                        UserDefaults.standard.set(true, forKey: AppStorageKeys.isSignedIn.rawValue)
                                                    case .failure(_):
                                                        withAnimation {
                                                            infoMessage = "Code verified, but failed to sign in."
                                                            showGoToSignIn = true
                                                        }
                                                    }
                                                }
                                            }
                                            
                                        case .failure( _ as NSError):
                                            withAnimation {
                                                state = .invalid
                                                infoMessage = nil
                                                showResendButton = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if showResendButton {
                        ConcertlyButton(label: "Resend Code", style: .secondary) {
                            AuthenticationManager.shared.resendConfirmationCode(email: email) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success:
                                        withAnimation {
                                            value = ""
                                            state = .typing
                                            infoMessage = "Code resent. Check your email."
                                            showResendButton = false
                                        }
                                    case .failure(_):
                                        withAnimation {
                                            infoMessage = "Couldn't resend code. Try again."
                                        }
                                    }
                                }
                            }
                        }
                        .transition(.opacity)
                    }
                    
                    if let info = infoMessage {
                        Text(info)
                            .font(.system(size: 16, type: .Regular))
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .transition(.opacity)
                    }
                    
                    if showGoToSignIn {
                        NavigationLink(destination: AuthChoiceView()) {
                            Text("Go to Sign In")
                        }
                        .font(.system(size: 16, type: .Medium))
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .onAppear {
                    isFocused = true
                }
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard)
    }
    
    @ViewBuilder
    func CharacterView(_ index: Int) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(borderColor(index), lineWidth: 2)
            .frame(width: 50, height: 70)
            .overlay {
                let stringValue = string(index)
                
                if stringValue != "" {
                    Text(stringValue)
                        .font(.system(size: 30, type: .Medium))
                        .transition(.blurReplace)
                }
            }
    }
    
    func string(_ index: Int) -> String {
        if value.count > index {
            let startIndex = value.startIndex
            let stringIndex = value.index(startIndex, offsetBy: index)
            
            return String(value[stringIndex])
        }
        
        return ""
    }
    
    func borderColor(_ index: Int) -> Color {
        switch state {
        case .typing:
            return .gray2
        case .valid:
            return .green
        case .invalid:
            return .red
        }
    }
}

enum TypingState {
    case typing
    case valid
    case invalid
}

#Preview {
    NavigationStack {
        RegisterCodeView(email: "owenevafey@gmail.com", password: "test123!")
    }
}

