import SwiftUI

public struct SnackbarView: View {
    
    public init(show: Binding<Bool>, message: String) {
        self._show = show
        self.message = message
    }
    
    @Binding public var show: Bool
    public var message: String
    
    public var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "exclamationmark.circle.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                
                Text(message)
                    .foregroundColor(.white)
                    .font(.system(size: 16, type: .Medium))
                    .frame(alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, minHeight: 35)
            .padding(.vertical, 10)
            .background(.red)
            .cornerRadius(15)
            .padding([.horizontal, .bottom], 15)
        }
        .onChange(of: show) {
            if show {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.show = false
                }
            }
        }
    }
}
