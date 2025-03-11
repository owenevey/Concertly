import SwiftUI

struct ForceUpdateView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack {
            Image(colorScheme == .light ? .forceUpdateGradientLight : .forceUpdateGradientDark)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 25, weight: .semibold))
                
                Text("Force Update")
                    .font(.system(size: 25, type: .SemiBold))
                    .multilineTextAlignment(.center)
                
                Text("Please update to the latest version to keep using Concertly!")
                    .font(.system(size: 18, type: .Regular))
                    .multilineTextAlignment(.center)
                
                ConcertlyButton(label: "Open App Store", fitText: true) {
                    if let url = URL(string: "https://apps.apple.com/app/id1234567890"), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.foreground)
                    .shadow(color: .black.opacity(0.2), radius: 5)
            )
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    ForceUpdateView()
}
