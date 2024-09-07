import SwiftUI

struct SuggestedPlaces: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Places you might like")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding([.leading, .top, .trailing], 15)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 15){
                    
                    ForEach(suggestedPlaces, id: \.id) { place in
                        PlaceCard(place: place)
                    }
                    
                }
                .padding(15)
            }
        }
    }
}

#Preview {
    SuggestedPlaces()
}
