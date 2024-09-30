import SwiftUI

struct PopularSports: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Popular Sports")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                
                NavigationLink{ Text("More sports")} label: {
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
                    
                    ForEach(popularGames, id: \.id) { game in
                        GameCard(game: game)
                    }
                    
                }
                .padding(15)
            }
        }
    }
}

#Preview {
    PopularSports()
}
