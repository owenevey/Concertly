import SwiftUI

struct ErrorDestinationCard: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            StillShimmerView()
                .frame(width: 250, height: 150)
            
            VStack(alignment: .leading, spacing: 5) {
                StillShimmerView()
                    .frame(width: 150, height: 23)
                    .cornerRadius(5)
                
                StillShimmerView()
                    .frame(width: 100, height: 20)
                    .cornerRadius(5)
                
                StillShimmerView()
                    .frame(width: 200, height: 20)
                    .cornerRadius(5)
                
                StillShimmerView()
                    .frame(width: 200, height: 20)
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
    }
}

#Preview {
    NavigationStack {
        ErrorDestinationCard()
            .shadow(color: .black.opacity(0.2), radius: 5)
    }

}
