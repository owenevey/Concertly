import SwiftUI

struct EnterEmailView: View {
    
    @State var email: String = ""
    
    var body: some View {
        VStack(spacing: 30) {
            Text("First, enter your email")
                .font(.system(size: 25, type: .SemiBold))
            
            TextField("Email", text: $email)
                .submitLabel(.done)
                .disableAutocorrection(true)
                .font(.system(size: 17, type: .Regular))
                .padding(.vertical, 15)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.gray3, lineWidth: 2)
                )
            
            NavigationLink(destination: EnterPasswordView(email: email)) {
                Text("Next")
                    .font(.system(size: 17, type: .SemiBold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.accentColor)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: 15))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(!isValidEmail)
        }
        .padding(15)
        .navigationBarHidden(true)
    }
    
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailFormat).evaluate(with: email)
    }

}

#Preview {
    NavigationStack {
        EnterEmailView()
    }
}
