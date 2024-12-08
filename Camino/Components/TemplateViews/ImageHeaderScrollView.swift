import SwiftUI

struct ImageHeaderScrollView<HeaderContent: View, Content: View>: View {
    
    @Environment(\.dismiss) var dismiss
    
    
    let imageUrl: String?
    let headerContent: HeaderContent?
    let showBackButton: Bool
    let content: () -> Content
    
    init(
        imageUrl: String? = nil,
        headerContent: HeaderContent = Rectangle().foregroundColor(.clear),
        showBackButton: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.imageUrl = imageUrl
        self.headerContent = headerContent
        self.showBackButton = showBackButton
        self.content = content
    }
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                if let url = imageUrl {
                    AsyncImage(url: URL(string: url)) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Color.background
                            .frame(height: 300 + max(0, -offset))
                    }
                    .scaledToFill()
                    .frame(height: 300 + max(0, -offset))
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size
                    }
                    .transformEffect(.init(translationX: 0, y: -max(0, offset)))
                } else if let customHeader = headerContent {
                    customHeader
                        .frame(height: 300 + max(0, -offset))
                        .transformEffect(.init(translationX: 0, y: -max(0, offset)))
                }
                
                
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
                                .padding(.top, geometry.safeAreaInsets.top)
                                .padding(.leading, 20)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}
