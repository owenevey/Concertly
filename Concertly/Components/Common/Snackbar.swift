import SwiftUI

public struct SnackbarView: View {
    
    public init(show: Binding<Bool>, bgColor: Color, txtColor: Color, message: String) {
        self._show = show
        self.bgColor = bgColor
        self.txtColor = txtColor
        self.message = message
    }
    
    @Binding public var show: Bool
    public var bgColor: Color
    public var txtColor: Color
    public var message: String
    let paddingBottom = (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + 54
    
    public var body: some View {
        if self.show {
            VStack {
                Spacer()
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: "xmark")
                        .resizable()
                        .foregroundColor(txtColor)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                    
                    Text(message)
                        .foregroundColor(txtColor)
                        .font(.system(size: 16, type: .Medium))
                        .frame(alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
                .frame(maxWidth: .infinity, minHeight: 35)
                .padding(.vertical, 10)
                .background(bgColor)
                .cornerRadius(15)
                .padding(.horizontal, 15)
                .padding(.bottom, show ? self.paddingBottom : 0)
                .animation(.easeInOut)
            }
            .transition(.move(edge: .bottom))
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.show = false
                }
            }
        }
    }
}
