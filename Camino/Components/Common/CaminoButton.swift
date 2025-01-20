import SwiftUI

struct CaminoButton: View {
    let label: String
    var style: String = "primary"
    let action: () async -> Void
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Text(label)
                .font(.system(size: 18, type: .Medium))
                .foregroundStyle(style == "primary" ? .white : .primary)
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(
                    Group {
                        if style == "primary" {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.accentColor)
                        } else if style == "secondary" {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.primary, lineWidth: 3)
                        }
                    }
                    
                )
                .contentShape(RoundedRectangle(cornerRadius: 15))
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .buttonStyle(PlainButtonStyle())
        
    }
}

#Preview {
    CaminoButton(label: "Clear", style: "secondary", action: {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    })
    .padding(40)
    .background(Color.background)
}
