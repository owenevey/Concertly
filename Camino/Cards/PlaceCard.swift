import SwiftUI

struct PlaceCard: View {
    
    var place: Place
    
    var body: some View {
        
        NavigationLink {
            Text(place.name)
        }
        label: {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(place.name)
                        .font(Font.custom("Barlow-Bold", size: 20))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Text(place.country)
                        .font(Font.custom("Barlow-SemiBold", size: 16))
                        .foregroundStyle(.gray)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    Text(place.description)
                        .font(Font.custom("Barlow-SemiBold", size: 16))
                        .foregroundStyle(.gray)
                        .minimumScaleFactor(0.5)
                        .lineLimit(2, reservesSpace: true)
                }
                .padding(10)
                
                Image(place.imageString)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 234, height: 150)
                    .cornerRadius(12)
                    .clipped()
                
            }
            .padding(8)
            .frame(width: 250)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.card)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PlaceCard(place: suggestedPlaces[0])
}
