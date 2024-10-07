import SwiftUI

struct SportCard: View {
    var game: Game
    var body: some View {
        NavigationLink{
            Text(game.homeTeamName)
        }
        label: {
            VStack(alignment: .center, spacing: 10) {
                HStack(spacing: 25) {
                    VStack {
                        Image(game.homeTeamLogo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        Text(game.homeTeamName)
                            .font(Font.custom("Barlow-Bold", size: 18))
                            .frame(width: 50)
                    }
                    
                    Image(game.leagueLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    
                    VStack {
                        Image(game.awayTeamLogo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        Text(game.awayTeamName)
                            .font(Font.custom("Barlow-Bold", size: 18))
                            .frame(width: 50)
                    }
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("\(game.location), \(game.country)")
                        .font(Font.custom("Barlow-SemiBold", size: 14))
                        .foregroundStyle(.gray)
                    
                    Text(game.date)
                        .font(Font.custom("Barlow-SemiBold", size: 14))
                        .foregroundStyle(.gray)
                }
                
            }
            .padding(15)
            .frame(width: 250)
            
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.card)
            )
        }.buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SportCard(game: upcomingGames[0])
}
