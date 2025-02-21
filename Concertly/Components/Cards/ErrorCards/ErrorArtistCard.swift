import SwiftUI

struct ErrorArtistCard: View {
    
    var body: some View {
        StillShimmerView()
            .frame(width: 200, height: 230)
            .cornerRadius(20)
        }
}

#Preview {
    NavigationStack {
        ErrorArtistCard()
            .shadow(color: .black.opacity(0.2), radius: 5)
    }
}
