import SwiftUI

struct DeleteAccountView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var showHeaderBorder: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    BackButton()
                    
                    Text("Delete Account")
                        .font(.system(size: 30, type: .SemiBold))
                }
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .frame(height: 1)
                    .overlay(.gray2)
                    .opacity(showHeaderBorder ? 1 : 0)
                    .animation(.linear(duration: 0.1), value: showHeaderBorder)
            }
            .background(Color.background)
            
            VStack(spacing: 20) {
                
                Text("Are you sure?")
                    .font(.system(size: 25, type: .SemiBold))
                    .padding(.top, 200)
                
                Text("This action is irreversible, and you'll lose all your data.")
                    .font(.system(size: 17, type: .Regular))
                    .padding(.horizontal, 30)
                    .multilineTextAlignment(.center)
                
                ConcertlyButton(label: "Delete Account", style: .warning) {
                    AuthenticationManager.shared.deleteAccount(completion: { _ in })
                }
                .frame(width: 200)
                
                Button {

                } label: {
                    Text("No thanks")
                        .font(.system(size: 17, type: .Regular))
                        .foregroundStyle(.gray3)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        DeleteAccountView()
    }
}
