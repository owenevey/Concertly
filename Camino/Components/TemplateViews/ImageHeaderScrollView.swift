import SwiftUI

struct ImageHeaderScrollView<HeaderContent: View, Content: View>: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isTitleVisible: Bool = true
    
    let title: String
    let imageUrl: String?
    let headerContent: HeaderContent?
    let showBackButton: Bool
    let content: () -> Content
    
    init(
        title: String,
        imageUrl: String? = nil,
        headerContent: HeaderContent? = EmptyView(),
        showBackButton: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
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
                    ImageLoader(url: url, contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 300 + max(0, -offset))
                        .transformEffect(.init(translationX: 0, y: -max(0, offset)))
                        .clipped()
                    
                } else if let customHeader = headerContent {
                    customHeader
                        .frame(width: UIScreen.main.bounds.width, height: 300 + max(0, -offset))
                        .transformEffect(.init(translationX: 0, y: -max(0, offset)))
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            
                        content()
                            .background(Color.background)
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
                        TranslucentBackButton()
                            .padding(.top, geometry.safeAreaInsets.top)
                        Spacer()
                    }
                }
                
                GeneralHeader(title: title)
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
            .navigationBarHidden(true)
    }
}
