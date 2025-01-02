//import SwiftUI
//
//struct SportCard: View {
//    @Namespace private var namespace
//    let id = "UIElement"
//    
//    var game: Game
//    
//    var body: some View {
//        NavigationLink{
//            Text(game.homeTeamName)
//                .navigationBarHidden(true)
//                .navigationTransition(.zoom(sourceID: id, in: namespace))
//        }
//        label: {
//            VStack(alignment: .center, spacing: 10) {
//                HStack(spacing: 25) {
//                    VStack {
//                        Image(game.homeTeamLogo)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 50, height: 50)
//                        Text(game.homeTeamName)
//                            .font(.system(size: 18, type: .SemiBold))
//                            .frame(width: 50)
//                    }
//                    
//                    Image(game.leagueLogo)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 40, height: 40)
//                    
//                    VStack {
//                        Image(game.awayTeamLogo)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 50, height: 50)
//                        Text(game.awayTeamName)
//                            .font(.system(size: 18, type: .SemiBold))
//                            .frame(width: 50)
//                    }
//                }
//                
//                VStack(alignment: .center, spacing: 5) {
//                    Text("\(game.location), \(game.country)")
//                        .font(.system(size: 14, type: .Regular))
//                        .foregroundStyle(.gray3)
//                    
//                    Text(game.date)
//                        .font(.system(size: 14, type: .Regular))
//                        .foregroundStyle(.gray3)
//                }
//                
//            }
//            .padding(15)
//            .frame(width: 250)
//            .clipShape(RoundedRectangle(cornerRadius: 20))
//            .background(
//                RoundedRectangle(cornerRadius: 20)
//                    .fill(Color.foreground)
//            )
//        }.buttonStyle(PlainButtonStyle())
//            .matchedTransitionSource(id: id, in: namespace)
//    }
//}
//
//#Preview {
//    NavigationStack {
//        SportCard(game: upcomingGames[0])
//            .shadow(color: .black.opacity(0.2), radius: 5)
//    }
//}
