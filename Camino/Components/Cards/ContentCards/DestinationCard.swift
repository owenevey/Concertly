import SwiftUI

struct DestinationCard: View {
    @Namespace private var namespace
    let id = "UIElement"
    
    var destination: Destination
    
    var body: some View {
        
        NavigationLink {
            DestinationView(destination: destination)
                .navigationBarHidden(true)
                .navigationTransition(.zoom(sourceID: id, in: namespace))
        }
        label: {
            VStack(alignment: .leading, spacing: 0) {                
                ImageLoader(url: destination.images[0], contentMode: .fill)
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
                        .font(.system(size: 17, type: .Regular))
                        .foregroundStyle(.gray3)
                        .minimumScaleFactor(0.9)
                        .lineLimit(2, reservesSpace: true)
                }
                .padding(15)
                
            }
            .frame(width: 250)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.foreground)
            )
            
        }
        .buttonStyle(PlainButtonStyle())
        .matchedTransitionSource(id: id, in: namespace)
    }
}

//#Preview {
//    NavigationStack {
//        PlaceCard(place: suggestedPlaces[6])
//            .shadow(color: .black.opacity(0.2), radius: 5)
//    }
//    
//}
