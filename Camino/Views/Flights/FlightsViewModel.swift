import Foundation
import SwiftUI

final class FlightsViewModel: ObservableObject {
    
    @Binding var flightsResponse: ApiResponse<FlightInfo>
    @Binding var fromAirport: String
    @Binding var toAirport: String
    @Binding var fromDate: Date
    @Binding var toDate: Date
    
    @Published var airlineFilter: [String: (imageURL: String, isEnabled: Bool)] = [:]
    
    init(flightsResponse: Binding<FlightInfo>,
         fromAirport: Binding<String>,
         toAirport: Binding<String>,
         fromDate: Binding<Date>,
         toDate: Binding<Date>) {
        self._flightsResponse = flightsResponse
        self._fromAirport = fromAirport
        self._toAirport = toAirport
        self._fromDate = fromDate
        self._toDate = toDate
    }
    
    var filteredFlights: [FlightItem] {
        return (flightData.bestFlights + flightData.otherFlights).filter { flightItem in
            guard let firstFlight = flightItem.flights.first else { return false }
            return airlineFilter[firstFlight.airline]?.isEnabled ?? false
        }
    }
}
