import SwiftUI

struct TrendingConcerts: View {
    
    let concerts: [Concert]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Trending Concerts")
                    .font(Font.custom("Barlow-Bold", size: 23))
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
                    ForEach(concerts, id: \.id) { concert in
                        ConcertCard(concert: concert)
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
    TrendingConcerts(concerts: hotConcerts)
}
