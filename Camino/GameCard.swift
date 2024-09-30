import SwiftUI

struct GameCard: View {
    
    let game: Game
    
    var body: some View {
        NavigationLink{
            Text("Test")}
    label: {
        
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 40) {
                VStack {
                    
                    Image(game.homeTeamLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text(game.homeTeamName)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                }
                
                
                VStack {
                    Image(game.awayTeamLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text(game.awayTeamName)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                }
            }.frame(width: 170)
            
            
            Text("🗓️ \(game.date)")
                .font(.subheadline)
            
            HStack(alignment: .top, spacing: 2) {
                Text("🏟️")
                    .font(.subheadline)
                VStack(alignment: .leading) {
                    Text("\(game.location),")
                        .font(.subheadline)
                    Text(game.country)
                        .font(.subheadline)
                }
            }
            
            Text("💸 Tickets from $120")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.green)
            
        }
        .cornerRadius(15)
        .padding(15)
        .frame(width: 200)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 242 / 255, green: 245 / 255, blue: 248 / 255))
        )
    }.buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    GameCard(game: popularGames[0])
}
