import SwiftUI

struct FlightDeals: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Flight Deals")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                NavigationLink{ Text("More deals")} label: {
                    HStack {
                        Text("See More")
                            .font(.system(size: 16))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16))
                    }
                }.buttonStyle(PlainButtonStyle())
            }
            .padding([.leading, .top, .trailing], 15)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 15){
                    
                    ForEach(suggestedPlaces.reversed(), id: \.id) { place in
                        PlaceCard(place: place)
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
