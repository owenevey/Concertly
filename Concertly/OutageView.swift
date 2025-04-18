import SwiftUI

struct OutageView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack {
            Image(colorScheme == .light ? .fullScreenGradientLight : .fullScreenGradientDark)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                Image(systemName: "icloud.slash")
                    .font(.system(size: 30, weight: .semibold))
                
                Text("Outage")
                    .font(.system(size: 25, type: .SemiBold))
                    .multilineTextAlignment(.center)
                
                Text("Concertly is temporarily down for maintenance")
                    .font(.system(size: 18, type: .Regular))
                    .multilineTextAlignment(.center)

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
    OutageView()
}
