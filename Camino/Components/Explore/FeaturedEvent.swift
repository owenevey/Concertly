import SwiftUI

struct FeaturedEvent: View {
    @Namespace private var namespace
    let id = "UIElement"
    
    var event: Concert?
    let status: Status
    let onRetry: (() async -> Void)
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Featured Event")
                    .font(.system(size: 23, type: .SemiBold))
                Spacer()
            }
            
            if status == .error {
                HStack {
                    Text("Error fetching event")
                    Button("Retry") {
                        Task {
                            await onRetry()
                        }
                    }
                }
                .font(.system(size: 18, type: .Regular))
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.opacity)
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
        .animation(.easeInOut, value: status)
    }
}

#Preview {
    @Previewable @State var status = Status.error
    VStack {
        Spacer()
        NavigationStack {
            FeaturedEvent(event: hotConcerts[0], status: status, onRetry: {
                Task {
                    status = .loading
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    status = .error
                }
            })
            .shadow(color: .black.opacity(0.2), radius: 5)
        }
        Spacer()
    }
    .background(Color.background)
}



