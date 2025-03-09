import SwiftUI

struct ImageViewHeader: View {
    
    var title: String
    var rightIcon: String? = nil
    var rightIconFilled: Bool? = nil
    var onRightIconTap: (() async -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 15) {
                BackButton(showBackground: true)
                    .padding(.leading, 15)
                
                Text(title)
                    .font(.system(size: 23, type: .Medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                
                Spacer()
                
                if let rightIcon = rightIcon, let rightIconFilled = rightIconFilled {
                    Button {
                        Task {
                            await onRightIconTap?()
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .frame(width: 35, height: 35)
                            .overlay(
                                Image(systemName: rightIconFilled ? "\(rightIcon).fill" : rightIcon)
                                    .font(.system(size: 17))
                                    .fontWeight(.semibold)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.trailing, 15)
            .padding(.bottom, 5)
            .background(Color.background)
            
            Divider()
                .frame(height: 1.5)
                .overlay(.gray2)
        }
        
    }
}

#Preview {
    VStack {
        Spacer()
        ImageViewHeader(title: "Dua Lipa")
        Spacer()
    }
    .background(Color.green)
    
}
