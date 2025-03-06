import SwiftUI

struct BackButton: View {
    
    var showBackground: Bool = false
    var showX: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(
            action: {
                dismiss()
            }
        ) {
            if showBackground {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .frame(width: 35, height: 35)
                    .overlay(
                        Image(systemName: showX ? "xmark" : "chevron.backward")
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                    )
                    .padding(.leading, 15)
            } else {
                Image(systemName: showX ? "xmark" : "chevron.backward")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .padding(.leading, 15)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {    
    ConcertView(concert: hotConcerts[0])
}
