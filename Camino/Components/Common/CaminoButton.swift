import SwiftUI

struct CaminoButton: View {
    let label: String
    let action: () async -> Void

    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Text(label)
                .font(.system(size: 18, type: .Medium))
                .foregroundStyle(.white)
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.accentColor)
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .buttonStyle(PlainButtonStyle())
        
    }
}

#Preview {
    ErrorView(text: "Error fetching airports", action: {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    })
}
