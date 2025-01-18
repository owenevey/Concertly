import Foundation
import SwiftUI

struct ErrorFeaturedEventItem: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            StillShimmerView()
                .frame(width: UIScreen.main.bounds.width - 30, height: (UIScreen.main.bounds.width - 30) * 0.6)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            VStack(alignment: .leading, spacing: 5) {
                StillShimmerView()
                    .frame(width: 250, height: 26)
                    .cornerRadius(5)
                
                StillShimmerView()
                    .frame(width: 175, height: 21)
                    .cornerRadius(5)
                StillShimmerView()
                    .frame(width: 175, height: 21)
                    .cornerRadius(5)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack {
        Spacer()
        ErrorFeaturedEventItem()
        Spacer()
    }
    .background(Color.background)
}
