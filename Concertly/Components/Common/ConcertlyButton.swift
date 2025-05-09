import SwiftUI

struct ConcertlyButton: View {
    let label: String
    var style: ConcertlyButtonStyle = .primary
    var fitText: Bool = false
    let action: () async -> Void
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Text(label)
                .font(.system(size: 17, type: .SemiBold))
                .foregroundStyle(style == .secondary ? .primary : Color.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .frame(maxWidth: fitText ? nil : .infinity)
                .background(
                    Group {
                        if style == .primary {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.accentColor)
                        } else if style == .secondary {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.primary, lineWidth: 3)
                        } else if style == .warning {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.red)
                        }
                    }
                    
                )
                .contentShape(RoundedRectangle(cornerRadius: 15))
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum ConcertlyButtonStyle: String {
    case primary
    case secondary
    case warning
}

#Preview {
    ConcertlyButton(label: "Clear", style: .primary, fitText: true, action: {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    })
    .padding(40)
    .background(Color.background)
}
