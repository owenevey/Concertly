import SwiftUI

struct ImageHeaderScrollView<Content: View>: View {
    
    @Environment(\.dismiss) var dismiss
    
    
    let imageUrl: String
    let content: () -> Content
    let showBackButton: Bool = true
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
            } placeholder: {
                Color.gray
                    .frame(height: 300 + max(0, -offset))
            }
            .scaledToFill()
            .frame(height: 300 + max(0, -offset))
            .containerRelativeFrame(.horizontal) { size, axis in
                size
            }
            .transformEffect(.init(translationX: 0, y: -max(0, offset)))
            
            if #available(iOS 18.0, *) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 300)
                        
                        content()
                    }
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size
                    }
                }
                .ignoresSafeArea(edges: .top)
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    return geo.contentOffset.y
                } action: { oldValue, newValue in
                    offset = newValue
                }
            } else {
                // Fallback on earlier versions
            }
            
            if showBackButton {
                HStack {
                    Button(action: {dismiss()}) {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "arrow.backward")
                                    .font(.system(size: 20))
                            )
                            .padding(.top, 60)
                            .padding(.leading, 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
            }
        }
    }
}
