import SwiftUI

struct TranslucentBackButton: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(
            action: {
                dismiss()
            }
        ) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                )
                .padding(.leading, 15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TranslucentBackButton()
}
