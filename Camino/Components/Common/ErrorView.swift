import SwiftUI

struct ErrorView: View {
    
    var text: String
    var action: () async -> Void  // Make this an async closure
    
    var body: some View {
        VStack(spacing: 15) {
            Text(text)
                .font(.system(size: 18, weight: .medium))
            
            Button {
                Task {
                    await action()
                }
            } label: {
                Text("Retry")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.accentColor)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(height: 250)
    }
}

#Preview {
    ErrorView(text: "Error fetching airports", action: {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    })
}
