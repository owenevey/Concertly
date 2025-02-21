import Foundation
import SwiftUI

struct FallbackFeaturedEventItem: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ShimmerView()
                .frame(width: UIScreen.main.bounds.width - 30, height: (UIScreen.main.bounds.width - 30) * 0.6)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            VStack(alignment: .leading, spacing: 5) {
                ShimmerView()
                    .frame(width: 250, height: 27)
                    .cornerRadius(5)
                
                ShimmerView()
                    .frame(width: 175, height: 22)
                    .cornerRadius(5)
                ShimmerView()
                    .frame(width: 175, height: 22)
                    .cornerRadius(5)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack {
        Spacer()
        FallbackFeaturedEventItem()
        Spacer()
    }
    .background(Color.background)
}
