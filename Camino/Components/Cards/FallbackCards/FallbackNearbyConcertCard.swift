import SwiftUI

struct FallbackNearbyConcertCard: View {
    var body: some View {
        HStack(spacing: 0) {
            ShimmerView()
                .frame(width: 150, height: 120)
            
            VStack(alignment: .leading, spacing: 5) {
                ShimmerView()
                    .frame(width: 200, height: 24)
                    .cornerRadius(5)
                
                ShimmerView()
                    .frame(width: 150, height: 21)
                    .cornerRadius(5)
                
                ShimmerView()
                    .frame(width: 100, height: 21)
                    .cornerRadius(5)
            }
            .padding(15)
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 30)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.foreground)
        )
    }
}

#Preview {
    NavigationStack {
        VStack {
            Spacer()
            FallbackNearbyConcertCard()
                .shadow(color: .black.opacity(0.2), radius: 5)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
    
}
