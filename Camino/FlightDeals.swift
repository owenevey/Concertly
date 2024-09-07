import SwiftUI

struct FlightDeals: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Flight Deals")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding([.leading, .top, .trailing], 15)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 15){
                    
                    ForEach(suggestedPlaces.reversed(), id: \.id) { place in
                        PlaceCard(place: place, minPrice: 200)
                    }
                    
                }
                .padding(15)
            }
        }
    }
}

#Preview {
    FlightDeals()
}
