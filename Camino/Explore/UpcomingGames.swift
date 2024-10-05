import SwiftUI

struct UpcomingGames: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Upcoming Games")
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
                    ForEach(upcomingGames, id: \.id) { game in
                        SportCard(game: game)
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
    UpcomingGames()
}
