import SwiftUI
import FirebaseAnalytics

struct DestinationCard: View {
    @EnvironmentObject var animationManager: AnimationManager
    
    var destination: Destination
    
    var body: some View {
        NavigationLink(value: destination) {
            VStack(alignment: .leading, spacing: 0) {
                ImageLoader(url: destination.imageUrl, contentMode: .fill)
                    .frame(width: 250, height: 150)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(destination.name)
                        .font(.system(size: 20, type: .SemiBold))
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                    
                    Text(destination.countryName)
                        .font(.system(size: 17, type: .Regular))
                        .foregroundStyle(.gray3)
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                    
                    Text(destination.shortDescription)
                        .font(.system(size: 16, type: .Regular))
                        .foregroundStyle(.gray3)
                        .minimumScaleFactor(0.9)
                        .lineLimit(2, reservesSpace: true)
                }
                .padding([.horizontal, .bottom], 15)
                .padding(.top, 10)
            }
            .frame(width: 250)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.foreground)
            )
            .matchedTransitionSource(id: destination.id, in: animationManager.animation) {
                $0
                    .background(.clear)
                    .clipShape(.rect(cornerRadius: 20))
            }
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(TapGesture().onEnded {
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                AnalyticsParameterItemID: "id-\(destination.id)",
                AnalyticsParameterItemName: destination.name,
              AnalyticsParameterContentType: "cont",
            ])
        })
    }
}

//#Preview {
//    NavigationStack {
//        PlaceCard(place: suggestedPlaces[6])
//            .shadow(color: .black.opacity(0.2), radius: 5)
//    }
//    
//}
