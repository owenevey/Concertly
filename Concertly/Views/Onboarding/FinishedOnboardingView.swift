import SwiftUI

struct FinishedOnboardingView: View {
    
    @AppStorage("Has Seen Onboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 72, weight: .regular))
                    .foregroundStyle(.accent)
                
                Text("All Set!")
                    .font(.system(size: 30, type: .SemiBold))
                    .foregroundStyle(.accent)
                    .padding(.top, 10)
                
                
                Spacer()
                
                Button {
                    hasSeenOnboarding = true
                } label: {
                    Text("Start Exploring")
                        .font(.system(size: 18, type: .Medium))
                        .foregroundStyle(.white)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.accentColor)
                            
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 15))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(width: 300)
                }
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    FinishedOnboardingView()
}
