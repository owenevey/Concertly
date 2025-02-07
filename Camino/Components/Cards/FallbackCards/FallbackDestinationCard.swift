import SwiftUI

struct FallbackDestinationCard: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ShimmerView()
                .frame(width: 250, height: 150)
            
            VStack(alignment: .leading, spacing: 5) {
                ShimmerView()
                    .frame(width: 150, height: 24)
                    .cornerRadius(5)
                
                ShimmerView()
                    .frame(width: 100, height: 21)
                    .cornerRadius(5)
                
                ShimmerView()
                    .frame(width: 200, height: 21)
                    .cornerRadius(5)
                
                ShimmerView()
                    .frame(width: 200, height: 21)
                    .cornerRadius(5)
            }
            .padding([.horizontal, .bottom], 15)
            .padding(.top, 10)
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
        FallbackDestinationCard()
            .shadow(color: .black.opacity(0.2), radius: 5)
    }

}
