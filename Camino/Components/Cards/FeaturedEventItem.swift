import Foundation
import SwiftUI

struct FeaturedEventItem: View {
    
    @Namespace private var namespace
    let id = "UIElement"
    
    var event: Concert
    
    var body: some View {
        NavigationLink{
            ConcertView(concert: event)
                .navigationBarHidden(true)
                .navigationTransition(.zoom(sourceID: id, in: namespace))
        }
        label: {
            VStack(alignment: .leading, spacing: 10) {
                AsyncImage(url: URL(string: event.imageUrl)) { image in
                    image
                        .resizable()
                } placeholder: {
                    Color.foreground
                        .frame(width: 250, height: 250)
                }
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width - 30, height: (UIScreen.main.bounds.width - 30) * 0.6)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(event.name)
                        .font(.system(size: 23, type: .SemiBold))
                    //                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                    
                    
                    Text(event.cityName)
                        .font(.system(size: 18, type: .Regular))
                        .foregroundStyle(.gray3)
                    //                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                    
                    Text(event.dateTime.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 18, type: .Regular))
                        .foregroundStyle(.gray3)
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
        .matchedTransitionSource(id: id, in: namespace)
    }
}


#Preview {
    NavigationStack {
        FeaturedEventItem(event: hotConcerts[0])
    }
}
