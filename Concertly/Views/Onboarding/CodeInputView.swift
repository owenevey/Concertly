import SwiftUI
import AWSCognitoIdentityProvider

struct CodeInputView: View {
    
    var email: String
    var password: String
    
    @State private var infoMessage: String? = nil
    @State private var showResendButton: Bool = false
    
    @State var value: String = ""
    @State var state: TypingState = .typing
    @FocusState var isActive
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                Text("Enter the code sent to your email")
                    .font(.system(size: 23, type: .SemiBold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 90)
                    .padding(.bottom, 30)
                
                HStack {
                    ForEach(0..<6, id: \.self) { index in
                        CharacterView(index)
                    }
                }
                .compositingGroup()
                .background {
                    TextField("", text: $value)
                        .focused($isActive)
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
                    isActive = true
                }
                .onChange(of: value) { oldValue, newValue in
                    value = String(newValue.prefix(6))
                    if value.count == 6 {
                        Task { @MainActor in
                            AuthenticationService.shared.confirmSignUp(email: email, confirmationCode: value) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success:
                                        withAnimation {
                                            state = .valid
                                        }
                                        Task {
                                            try? await Task.sleep(nanoseconds: 1_000_000_000)
                                            
                                            AuthenticationService.shared.signIn(email: email, password: password) { result in
                                                DispatchQueue.main.async {
                                                    switch result {
                                                    case .success:
                                                        infoMessage = nil
                                                    case .failure(_):
                                                        withAnimation {
                                                            infoMessage = "Code verified, but failed to sign in."
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                    case .failure( _ as NSError):
                                        withAnimation {
                                            state = .invalid
                                            showResendButton = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                if showResendButton {
                    ConcertlyButton(label: "Resend Code", fitText: true) {
                        AuthenticationService.shared.resendConfirmationCode(email: email) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success:
                                    withAnimation {
                                        value = ""
                                        state = .typing
                                        infoMessage = "Code resent. Check your email."
                                    }
                                case .failure(_):
                                    withAnimation {
                                        infoMessage = "Couldn't resend code. Try again."
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 30)
                    .transition(.opacity)
                }
                
                if let info = infoMessage {
                    Text(info)
                        .font(.system(size: 16, type: .Regular))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.top, 10)
                        .transition(.opacity)
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .onAppear {
                isActive = true
            }
        }
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
    CodeInputView(email: "owenevafey@gmail.com", password: "test123!")
}

