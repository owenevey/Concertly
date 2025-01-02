import SwiftUI

struct PlaceCard: View {
    @Namespace private var namespace
    let id = "UIElement"
    
    var place: Place
    
    var body: some View {
        
        NavigationLink {
            Text(place.name)
                .navigationBarHidden(true)
                .navigationTransition(.zoom(sourceID: id, in: namespace))
        }
        label: {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(place.name)
                        .font(.system(size: 20, type: .SemiBold))
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                    
                    Text(place.countryName)
                        .font(.system(size: 16, type: .Regular))
                        .foregroundStyle(.gray3)
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                    
                    Text(place.shortDescription)
                        .font(.system(size: 16, type: .Regular))
                        .foregroundStyle(.gray3)
                        .minimumScaleFactor(0.75)
                        .lineLimit(2, reservesSpace: true)
                }
                .padding(15)
                
                
                AsyncImage(url: URL(string: place.images[0])) { image in
                    image
                        .resizable()
                } placeholder: {
                    Color.foreground
                        .frame(width: 250, height: 250)
                }
                .scaledToFill()
                .frame(width: 250, height: 150)
                .clipped()
                
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
