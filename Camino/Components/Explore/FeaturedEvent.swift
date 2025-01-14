import SwiftUI

struct FeaturedEvent: View {
    @Namespace private var namespace
    let id = "UIElement"
    
    var event: Concert?
    let status: Status
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Featured Event")
                    .font(.system(size: 23, type: .SemiBold))
                Spacer()
            }
            switch status {
            case .loading, .empty:
                FallbackFeaturedEventItem()
                    .shadow(color: .black.opacity(0.2), radius: 5)
            case .success:
                if let event {
                    FeaturedEventItem(event: event)
                        .shadow(color: .black.opacity(0.2), radius: 5)
                }
            case .error:
                ErrorFeaturedEventItem()
                    .shadow(color: .black.opacity(0.2), radius: 5)
            }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 5)
    }
}

#Preview {
    VStack {
        Spacer()
        NavigationStack {
            FeaturedEvent(event: hotConcerts[0], status: .success)
                .shadow(color: .black.opacity(0.2), radius: 5)
        }
        Spacer()
    }
    .background(Color.background)
}



