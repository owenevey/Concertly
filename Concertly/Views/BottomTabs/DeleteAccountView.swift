import SwiftUI

struct DeleteAccountView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var isLoading = false
    
    @State private var showHeaderBorder: Bool = false
    
    @AppStorage(AppStorageKeys.authStatus.rawValue) var authStatus: AuthStatus = .registered
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    BackButton()
                    
                    Text("Delete Account")
                        .font(.system(size: 25, type: .SemiBold))
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
                
                Button {
                    isLoading = true
                    AuthenticationManager.shared.deleteAccount(completion: { _ in
                        Task {
                            try await deleteUser()
                            clearLocalUserData()
                            isLoading = false
                            authStatus = .loggedOut
                            router.reset()
                        }
                    })
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
                        .frame(width: 50, height: isLoading ? nil : 1)
                        .transition(.opacity)
                        
                        Text("Delete Account")
                            .font(.system(size: 17, type: .SemiBold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .frame(alignment: .center)
                        
                        Color.clear
                            .padding(.trailing, 15)
                            .frame(width: 50, height: 1)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.red)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: 15))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(width: 300)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(isLoading)
                
                Button {
                    dismiss()
                } label: {
                    Text("No thanks")
                        .font(.system(size: 17, type: .Regular))
                        .foregroundStyle(.gray3)
                }
                .padding(.top, 5)
                
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
            .environmentObject(Router())
    }
}
