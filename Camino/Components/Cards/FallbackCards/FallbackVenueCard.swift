import SwiftUI

struct FallbackVenueCard: View {
    
    var body: some View {
        ShimmerView()
            .frame(width: 200, height: 230)
            .cornerRadius(20)
        }
}

#Preview {
    NavigationStack {
        FallbackVenueCard()
            .shadow(color: .black.opacity(0.2), radius: 5)
    }
}
