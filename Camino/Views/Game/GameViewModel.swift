import Foundation
import SwiftUI

class GameViewModel: TripViewModelProtocol {
    var game: Game
    
    @Published var tripStartDate: Date
    @Published var tripEndDate: Date
    @Published var flightsResponse: ApiResponse<FlightsResponse> = ApiResponse<FlightsResponse>()
    @Published var hotelsResponse: ApiResponse<HotelsResponse> = ApiResponse<HotelsResponse>()
    @Published var flightsPrice: Int = 0
    @Published var hotelsPrice: Int = 0
    @Published var cityName: String = ""
    
    init(game: Game) {
        self.game = game
        
        let calendar = Calendar.current
        self.tripStartDate = calendar.date(byAdding: .day, value: -1, to: game.dateTime) ?? Date()
        self.tripEndDate = calendar.date(byAdding: .day, value: 1, to: game.dateTime) ?? Date()
        self.cityName = game.cityName
    }
    
    var ticketPrice: Int {
        Int(game.minPrice)
    }
    
    var totalPrice: Int {
        ticketPrice + hotelsPrice + flightsPrice
    }
    
    func getDepartingFlights() async {
        self.flightsResponse = ApiResponse(status: .loading)
        
        do {
            let fetchedFlights = try await fetchDepartureFlights(lat: game.latitude,
                                                                 long: game.longitude,
                                                                 fromAirport: homeAirport,
                                                                 fromDate: tripStartDate.traditionalFormat(),
                                                                 toDate: tripEndDate.traditionalFormat())
            
            withAnimation(.easeInOut) {
                self.flightsResponse = ApiResponse(status: .success, data: fetchedFlights)
                self.flightsPrice = fetchedFlights.bestFlights.first?.price ?? 0
            }
            
        } catch {
            print("Error fetching flights: \(error)")
            self.flightsResponse = ApiResponse(status: .error, error: error.localizedDescription)
        }
    }
    
    func getHotels() async {
        self.hotelsResponse = ApiResponse(status: .loading)
        
        do {
            let fetchedHotels = try await fetchHotels(location: game.cityName,
                                                      fromDate: tripStartDate.traditionalFormat(),
                                                      toDate: tripEndDate.traditionalFormat())
            withAnimation(.easeInOut) {
                self.hotelsResponse = ApiResponse(status: .success, data: fetchedHotels)
                self.hotelsPrice = fetchedHotels.properties.first?.totalRate.extractedLowest ?? 0
            }
        } catch {
            print("Error fetching hotels: \(error)")
            self.hotelsResponse = ApiResponse(status: .error, error: error.localizedDescription)
        }
    }
}


func determineSportsLogo(for league: String) -> String {
    switch league {
    case "NFL":
        return "american.football.fill"
    case "NBA":
        return "basketball.fill"
    case "MLB":
        return "baseball.fill"
    default:
        return ""
    }
}

func determineSporsHeader(for league: String) -> String {
    switch league {
    case "NFL":
        return "nflStadium"
    case "NBA":
        return "nbaArena"
    case "MLB":
        return "mlbStadium"
    default:
        return ""
    }
}
