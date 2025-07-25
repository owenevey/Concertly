import SwiftUI
import SmoothGradient
import FirebaseAnalytics

struct VenueCard: View {
    @EnvironmentObject var animationManager: AnimationManager
    
    var venue: Venue
    
    var body: some View {
        NavigationLink(value: venue) {
            ImageLoader(url: venue.imageUrl, contentMode: .fill)
                .frame(width: 250, height: 200)
                .clipped()
                .overlay {
                    ZStack(alignment: .bottom) {
                        SmoothLinearGradient(
                            from: .clear,
                            to: .black.opacity(0.8),
                            startPoint: .top,
                            endPoint: .bottom,
                            curve: .easeInOut)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            Text(venue.name)
                                .font(.system(size: 23, type: .SemiBold))
                                .foregroundStyle(.white)
                                .minimumScaleFactor(0.9)
                                .lineLimit(2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 15)
                                .padding(.bottom, 10)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .matchedTransitionSource(id: venue.id, in: animationManager.animation) {
                    $0
                        .background(.clear)
                        .clipShape(.rect(cornerRadius: 20))
                }
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(TapGesture().onEnded {
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: "id-\(venue.id)",
                AnalyticsParameterItemName: venue.name,
              AnalyticsParameterContentType: "cont",
            ])
        })
    }
}

//#Preview {
//    NavigationStack {
//        VStack {
//            Spacer()
//            VenueCard(venue: Venue(
//                id: "KovZpZA7AAEA",
//                name: "Madison Square Garden",
//                imageUrl: "https://upload.wikimedia.org/wikipedia/commons/4/4b/Madison_Square_Garden_%28MSG%29_-_Full_%2848124330357%29.jpg"))
//            .shadow(color: .black.opacity(0.2), radius: 5)
//            Spacer()
//        }
//        .frame(maxWidth: .infinity)
//        .background(Color.background)
//    }
//}
