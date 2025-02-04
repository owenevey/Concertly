import SwiftUI

struct FallbackConcertCard: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ShimmerView()
                .frame(width: 250, height: 150)
            
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
        }
        .frame(width: 250)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.foreground)
        )
        .shadow(color: .clear, radius: 0)
    }
}

#Preview {
    NavigationStack {
        VStack {
            FallbackConcertCard()
        }
        .shadow(color: .black.opacity(0.2), radius: 5)
    }
}
