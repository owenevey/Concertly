import SwiftUI
import SmoothGradient
import FirebaseAnalytics

struct ImageHeaderScrollView<Content: View>: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isTitleVisible: Bool = true
    
    let saveConcertTip = SaveConcertTip()
    let followArtistTip = FollowArtistTip()
    
    let title: String
    let imageUrl: String
    let rightIcon: String?
    let rightIconFilled: Bool?
    var onRightIconTap: (() async -> Void)?
    let content: () -> Content
    
    init(
        title: String,
        imageUrl: String,
        rightIcon: String? = nil,
        rightIconFilled: Bool? = nil,
        onRightIconTap: (() async -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.imageUrl = imageUrl
        self.rightIcon = rightIcon
        self.rightIconFilled = rightIconFilled
        self.onRightIconTap = onRightIconTap
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
                                .minimumScaleFactor(0.5)
                                .background(
                                    SmoothLinearGradient(
                                        from: .clear,
                                        to: .black.opacity(0.8),
                                        startPoint: .top,
                                        endPoint: .bottom,
                                        curve: .easeInOut)
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
                    
                    let threshold = 300 - 70 - geometry.safeAreaInsets.top
                    
                    withAnimation(.linear(duration: 0.1)) {
                        if newValue > threshold && isTitleVisible {
                            isTitleVisible = false
                        } else if newValue <= threshold && !isTitleVisible {
                            isTitleVisible = true
                        }
                    }
                }
                
                HStack {
                    BackButton(showBackground: true)
                        .padding(.leading, 15)
                    
                    Spacer()
                    
                    if let rightIcon = rightIcon, let rightIconFilled = rightIconFilled {
                        Button {
                            if rightIcon == "star" {
                                followArtistTip.invalidate(reason: .actionPerformed)
                                Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                                    AnalyticsParameterItemName: "toggle_follow_artist",
                                    AnalyticsParameterContentType: "cont",
                                ])
                            } else {
                                saveConcertTip.invalidate(reason: .actionPerformed)
                                Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                                    AnalyticsParameterItemName: "toggle_save_concert",
                                    AnalyticsParameterContentType: "cont",
                                ])
                            }
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
                                .padding(.trailing, 15)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .popoverTip(rightIcon == "star" ? followArtistTip : saveConcertTip)
                    }
                }
                .padding(.top, geometry.safeAreaInsets.top)
                
                ImageViewHeader(title: title, rightIcon: rightIcon, rightIconFilled: rightIconFilled, onRightIconTap: onRightIconTap)
                    .opacity(isTitleVisible ? 0 : 1)
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
