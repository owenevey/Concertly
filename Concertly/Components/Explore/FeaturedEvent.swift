import SwiftUI

struct FeaturedEvent: View {
    
    var concert: Concert?
    let status: Status
    let onRetry: (() async -> Void)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Featured Event")
                    .font(.system(size: 20, type: .SemiBold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if status == .error {
                HStack {
                    Text("Error fetching event")
                    Button("Retry") {
                        Task {
                            await onRetry()
                        }
                    }
                }
                .font(.system(size: 16, type: .Regular))
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.opacity)
            }
            
            Group {
                switch status {
                case .loading, .empty:
                    if let concert = concert {
                        FeaturedEventItem(concert: concert)
                    } else {
                        FallbackFeaturedEventItem()
                    }
                case .success:
                    if let concert = concert {
                        FeaturedEventItem(concert: concert)
                    } else {
                        ErrorFeaturedEventItem()
                    }
                case .error:
                    if let concert = concert {
                        FeaturedEventItem(concert: concert)
                    } else {
                        ErrorFeaturedEventItem()
                    }
                }    
            }
            .shadow(color: .black.opacity(0.2), radius: 5)
            .padding(.top, 10)
            .padding(.bottom, 15)
        }
        .padding(.horizontal, 15)
        .animation(.easeInOut, value: status)
    }
}

#Preview {
    @Previewable @State var status = Status.error
    VStack {
        Spacer()
        NavigationStack {
            FeaturedEvent(concert: hotConcerts[0], status: status, onRetry: {
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



