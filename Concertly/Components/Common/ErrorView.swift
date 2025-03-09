import SwiftUI

struct ErrorView: View {
    
    var text: String
    var action: () async -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Text(text)
                .font(.system(size: 18, weight: .medium))
            
            ConcertlyButton(label: "Retry", fitText: true, action: action)
        }
        .frame(height: 250)
    }
}

#Preview {
    ErrorView(text: "Error fetching airports", action: {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    })
}
