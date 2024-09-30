import SwiftUI

struct ExploreView: View {
    
    
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    ExploreHeader()
                    ExplorePills()
                    SuggestedPlaces()
                    TrendingConcerts()
                    SuggestedPlaces()
                    TrendingConcerts()
                    TrendingConcerts()
                    Spacer()
                }.padding(.bottom, 100)
            }
        }
    }
}

#Preview {
    ExploreView()
}
