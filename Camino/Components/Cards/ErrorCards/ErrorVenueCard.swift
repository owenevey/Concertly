import SwiftUI

struct ErrorVenueCard: View {
    
    var body: some View {
        StillShimmerView()
            .frame(width: 250, height: 200)
            .cornerRadius(20)
        }
}

#Preview {
    NavigationStack {
        ErrorVenueCard()
            .shadow(color: .black.opacity(0.2), radius: 5)
    }
}
