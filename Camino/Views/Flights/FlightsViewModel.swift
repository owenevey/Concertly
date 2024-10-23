import Foundation
import SwiftUI

final class FlightsViewModel: ObservableObject {
    
    @Published var fromDate: Date
    @Published var toDate: Date
    @Published var flightsResponse: ApiResponse<FlightsResponse>
    
    @Published var fromAirport = homeAirport
    @Published var toAirport: String = "SAN"
    @Published var airlineFilter: [String: (imageURL: String, isEnabled: Bool)] = [:]
    
    init(fromDate: Date, toDate: Date, flightsResponse: ApiResponse<FlightsResponse>) {
        self.fromDate = fromDate
        self.toDate = toDate
        self.flightsResponse = flightsResponse
    }
    
    var filteredFlights: [FlightItem] {
        guard let data = flightsResponse.data else {
            print("returning none")
            return []
        }
        
        let allFlights = data.bestFlights + data.otherFlights
        return allFlights.filter { flightItem in
            guard let firstFlight = flightItem.flights.first else { return false }
            return airlineFilter[firstFlight.airline]?.isEnabled == true
        }
    }
    
    func getFlights() async {
        print("in getflights")
        self.flightsResponse = ApiResponse(status: .loading)
        
        do {
            let fetchedFlights = try await fetchDepartureFlights(fromAirport: homeAirport,
                                                                 toAirport: toAirport,
                                                                fromDate: fromDate.traditionalFormat(),
                                                                toDate: toDate.traditionalFormat())
            
            DispatchQueue.main.async {
                self.flightsResponse = ApiResponse(status: .success, data: fetchedFlights)
            }
            print(fetchedFlights)
        } catch {
            print("Error fetching flights: \(error)")
            DispatchQueue.main.async {
                self.flightsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
}
