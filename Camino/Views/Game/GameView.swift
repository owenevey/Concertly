import SwiftUI
import MapKit

struct GameView: View {
    
    var game: Game
    
    @StateObject var viewModel: GameViewModel
    
    init(game: Game) {
        self.game = game
        _viewModel = StateObject(wrappedValue: GameViewModel(game: game))
    }
    
    @State var hasAppeared: Bool = false
    
    var body: some View {
        ImageHeaderScrollView(
            headerContent:
                ZStack(alignment: .bottom) {
                    Image(determineSporsHeader(for: game.league))
                        .resizable()
                        .scaledToFill()
                        .containerRelativeFrame(.horizontal) { size, axis in
                            size
                        }
                        .zIndex(-1)
                    
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
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .shadow(color: Color(.black).opacity(0.5), radius: 10)
                    .padding(15)
                }
            
        ) {
                    VStack(spacing: 20) {
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(game.homeTeam) vs \(game.awayTeam)")
                                .font(.system(size: 30, type: .SemiBold))
                            
                            Text(game.dateTime.formatted(date: .complete, time: .omitted))
                                .font(.system(size: 18, type: .Regular))
                                .foregroundStyle(.gray3)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Minimum Price Summary")
                                .font(.system(size: 20, type: .SemiBold))
                            
                            Text("\(viewModel.tripStartDate.mediumFormat()) - \(viewModel.tripEndDate.mediumFormat())")
                                .font(.system(size: 16, type: .Regular))
                                .foregroundStyle(.gray3)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        VStack(spacing: 15) {
                            ForEach((LineItemType.eventItems(eventViewModel: viewModel, link: game.url)), id: \.title) { item in
                                switch item {
                                case .flights:
                                    LineItem(item: item, price: viewModel.flightsPrice, status: viewModel.flightsResponse.status)
                                case .hotel:
                                    LineItem(item: item, price: viewModel.hotelsPrice, status: viewModel.hotelsResponse.status)
                                    
                                case .ticket:
                                    LineItem(item: item, price: viewModel.ticketPrice, status: Status.success)
                                }
                            }
                            
                            Divider()
                                .frame(height: 2)
                                .overlay(.gray2)
                            
                            HStack {
                                Text("Total:")
                                    .font(.system(size: 18, type: .Medium))
                                Spacer()
                                Group {
                                    if viewModel.flightsResponse.status == .loading || viewModel.hotelsResponse.status == .loading {
                                        CircleLoadingView(ringSize: 20)
                                            .padding(.trailing, 10)
                                    } else if viewModel.flightsResponse.status == .success && viewModel.hotelsResponse.status == .success {
                                        Text("$\(viewModel.totalPrice)")
                                            .font(.system(size: 18, type: .Medium))
                                    } else if viewModel.flightsResponse.status == .error || viewModel.hotelsResponse.status == .error {
                                        Text("Error")
                                            .font(.system(size: 18, type: .Medium))
                                    }
                                }
                                .transition(.opacity)
                                .animation(.easeInOut, value: viewModel.totalPrice)
                            }
                            .padding(.horizontal, 10)
                            
                        }
                        
                        MapCard(addressToSearch: game.venueAddress, latitude: game.latitude, longitude: game.longitude, name: game.venueName, generalLocation: game.cityName)
                            .padding(.vertical, 10)
                        
                        Button {
                            print("Plan trip tapped")
                        } label: {
                            Text("Plan Trip")
                                .font(.system(size: 18, type: .Medium))
                                .foregroundStyle(.white)
                                .padding(12)
                                .containerRelativeFrame(.horizontal) { size, axis in
                                    size - 100
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.accent)
                                )
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(15)
                    .background(Color.background)
                    
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size
                    }
                }
                .background(Color.background)
                .onAppear {
                    if !hasAppeared {
                        Task {
                            await viewModel.getDepartingFlights()
                            await viewModel.getHotels()
                        }
                        hasAppeared = true
                    }
                }
    }
    
    
}
#Preview {
    NavigationStack {
        GameView(
            game: Game(
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
            )
        )
        .navigationBarHidden(true)
    }
}

