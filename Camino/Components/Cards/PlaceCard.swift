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
                    
                    Text(place.country)
                        .font(.system(size: 16, type: .Regular))
                        .foregroundStyle(.gray)
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                    
                    Text(place.description)
                        .font(.system(size: 16, type: .Regular))
                        .foregroundStyle(.gray)
                        .minimumScaleFactor(0.75)
                        .lineLimit(2, reservesSpace: true)
                }
                .padding(15)
                
                Image(place.imageString)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 150)
                    .clipped()
                
            }
            .frame(width: 250)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.card)
            )
            
        }
        .buttonStyle(PlainButtonStyle())
        .matchedTransitionSource(id: id, in: namespace)
        
    }
}

#Preview {
    NavigationStack {
        PlaceCard(place: suggestedPlaces[6])
            .shadow(color: .black.opacity(0.2), radius: 5)
    }
    
}
