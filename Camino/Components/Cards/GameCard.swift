import SwiftUI

struct GameCard: View {
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var namespace
    let id = "UIElement"
    
    var game: Game
    
    var body: some View {
        NavigationLink{
            GameView(game: game)
                .navigationBarHidden(true)
                .navigationTransition(.zoom(sourceID: id, in: namespace))
        }
        label: {
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Circle()
                        .fill(.accent)
                        .frame(width: 35, height: 35)
                        .overlay(
                            Image(systemName: determineSportsLogo(for: game.league))
                                .font(.system(size: 18))
                                .foregroundStyle(Color(.white))
                        )
                    
                    Text(game.league)
                        .font(.system(size: 20, type: .SemiBold))
                }
                
                HStack {
                    VStack {
                        Circle()
                            .fill(Color.fromHex(game.homeTeamColor))
                            .frame(width: 50, height: 50)
                        Text(game.homeTeam)
                            .font(.system(size: 16, type: .Medium))
                            .multilineTextAlignment(.center)
                            .lineLimit(2, reservesSpace: true)
                            .frame(width: 120)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Text("vs")
                        .font(.system(size: 18, type: .Medium))
                    
                    VStack {
                        Circle()
                            .fill(Color.fromHex(game.awayTeamColor))
                            .frame(width: 50, height: 50)
                        Text(game.awayTeam)
                            .font(.system(size: 16, type: .Medium))
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.75)
                            .lineLimit(2, reservesSpace: true)
                            .frame(width: 100, height: 40)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                
                
                HStack(spacing: 20) {
                    
                    Text(game.cityName)
                        .font(.system(size: 16, type: .Regular))
                        .foregroundStyle(.gray3)
                        .lineLimit(1)
                    
                    Text(game.dateTime.formatted(date: .abbreviated, time: .omitted))
                        .font(.system(size: 16, type: .Regular))
                        .foregroundStyle(.gray3)
                        .lineLimit(1)
                    
                }
                .frame(maxWidth: .infinity)
                
                
            }
            .frame(maxWidth: .infinity)
            .padding(15)
            .frame(width: 300)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .background(
                Image(colorScheme == .light ? "gradientLight" : "gradientDark")
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                
            )
        }
        .buttonStyle(PlainButtonStyle())
        .matchedTransitionSource(id: id, in: namespace)
        
    }
}


#Preview {
    NavigationStack {
        GameCard(game: Game(
            league: "NBA",
            id: UUID().uuidString,
            url: "https://example.com/game",
            homeTeam: "Los Angeles Lakers",
            awayTeam: "Golden State Warriors",
            homeTeamColor: "#a23b3b",
            awayTeamColor: "#f2a411",
            dateTime: Date(),
            minPrice: 75.0,
            maxPrice: 500.0,
            venueName: "Crypto.com Arena",
            venueAddress: "1111 S Figueroa St, Los Angeles, CA",
            cityName: "Los Angeles",
            latitude: 34.043017,
            longitude: -118.267254
        ))
        .shadow(color: .black.opacity(0.2), radius: 5)
    }
}
