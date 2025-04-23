import SwiftUI

struct CodeInputView: View {
    @FocusState private var isFocused: Bool
    @State private var code: String = ""
    private let maxDigits = 6

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .onChange(of: code) { newValue in
                    // Limit to maxDigits and strip non-numeric input
                    code = newValue.filter { $0.isNumber }.prefix(maxDigits).description
                }
                .frame(width: 0, height: 0)
                .opacity(0.01) // almost invisible but tappable
            
            // Display input visually
            HStack(spacing: 12) {
                ForEach(0..<maxDigits, id: \.self) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray2, lineWidth: 2)
                            .frame(width: 44, height: 55)

                        Text(code.digit(at: index))
                            .font(.system(size: 24, weight: .medium, design: .monospaced))
                    }
                }
            }
        }
        .contentShape(Rectangle()) // tap anywhere
        .onAppear {
            isFocused = true
        }
    }
}

#Preview {
    CodeInputView()
}

extension String {
    func digit(at index: Int) -> String {
        guard index < self.count else { return ""
        }
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return String(self[charIndex])
    }
}
