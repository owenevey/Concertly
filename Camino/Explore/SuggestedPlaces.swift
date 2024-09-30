import SwiftUI

struct SuggestedPlaces: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Suggested Places")
                    .font(Font.custom("Barlow-ExtraBold", size: 23))
                Spacer()
                NavigationLink{ Text("View More")} label: {
                    HStack {
                        Text("View More")
                            .font(Font.custom("Barlow-SemiBold", size: 16))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16))
                    }
                }.buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15){
                    ForEach(suggestedPlaces, id: \.id) { place in
                        PlaceCard(place: place)
                    }
                }
                .scrollTargetLayout()
                .padding(.top, 15)
            }
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.horizontal, 15)
        }
    }
}

#Preview {
    SuggestedPlaces()
}
