import SwiftUI

struct AuthLandingView: View {
    var body: some View {
        VStack {
            Text("Concertly")
                .font(.system(size: 40, type: .SemiBold))
                .foregroundStyle(.accent)
            
            NavigationLink(destination: EnterEmailView()) {
                HStack(spacing: 15) {
                    Image(systemName: "envelope")
                        .fontWeight(.semibold)
                    Text("Sign up with Email")
                        .font(.system(size: 18, type: .Regular))
                }
                .padding(15)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray3)
                        .padding(.horizontal, 15)
                )
            }
                        
            NavigationLink(destination: SignInView()) {
                Text("Sign In")
                    .font(.system(size: 18, type: .Medium))
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 25)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        AuthLandingView()
    }
}
