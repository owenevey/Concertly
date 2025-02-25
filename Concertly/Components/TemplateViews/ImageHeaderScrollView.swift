import SwiftUI

struct ImageHeaderScrollView<Content: View>: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isTitleVisible: Bool = true
    
    let title: String
    let imageUrl: String
    let showBackButton: Bool
    let content: () -> Content
    
    init(
        title: String,
        imageUrl: String,
        showBackButton: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.imageUrl = imageUrl
        self.showBackButton = showBackButton
        self.content = content
    }
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ImageLoader(url: imageUrl, contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 300 + max(0, -offset))
                    .transformEffect(.init(translationX: 0, y: -max(0, offset)))
                    .clipped()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottom) {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: UIScreen.main.bounds.width, height: 300)
                            
                            Text(title)
                                .font(.system(size: 40, type: .SemiBold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 15)
                                .padding(.bottom, 5)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(2)
                                .background(
                                    LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                                        .padding(.top, -50)
                                )
                        }
                        
                        content()
                            .background(Color.background)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                }
                .ignoresSafeArea(edges: .top)
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    return geo.contentOffset.y
                } action: { oldValue, newValue in
                    offset = newValue
                    
                    // Threshold for toggling title visibility
                    let threshold = 300 - 50 + 15 + 10 - geometry.safeAreaInsets.top
                    
                    withAnimation(.linear(duration: 0.3)) {
                        if newValue > threshold && isTitleVisible {
                            isTitleVisible = false // Hide title
                        } else if newValue <= threshold && !isTitleVisible {
                            isTitleVisible = true // Show title
                        }
                    }
                }
                
                if showBackButton {
                    HStack {
                        BackButton(showBackground: true)
                            .padding(.top, geometry.safeAreaInsets.top)
                        Spacer()
                    }
                }
                
                ImageViewHeader(title: title)
                    .opacity(isTitleVisible ? 0 : 1)
                    .animation(.linear(duration: 0.1), value: isTitleVisible)
                    .padding(.top, geometry.safeAreaInsets.top)
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}


#Preview {
    NavigationStack {
        ConcertView(concert: hotConcerts[0])
    }
}
