import Foundation
import SwiftUI

final class FlightsViewModel: ObservableObject {
    
    @Published var fromDate: Date
    @Published var toDate: Date
    @Published var flightsResponse: ApiResponse<FlightsResponse>
    
    @Published var fromAirport = homeAirport
    @Published var toAirport: String = "SAN"
    
    @Published var sortFlightsMethod = SortFlightsEnum.cheapest
    @Published var airlineFilter: [String: (imageURL: String, isEnabled: Bool)] = [:]
    @Published var stopsFilter: FilterStopsEnum = .any
    @Published var durationFilter: Int
    @Published var priceFilter: Int
    
    init(fromDate: Date, toDate: Date, flightsResponse: ApiResponse<FlightsResponse>) {
        self.fromDate = fromDate
        self.toDate = toDate
        self.flightsResponse = flightsResponse
        
        if let data = flightsResponse.data {
            let allFlights = data.bestFlights + data.otherFlights
            
            let durations = allFlights.map { $0.totalDuration }
            self.durationFilter = durations.max() ?? 0
            
            let prices = allFlights.map { $0.price }
            self.priceFilter = prices.max() ?? 0
        } else {
            self.durationFilter = 0
            self.priceFilter = 0
        }
    }
    
    var flightDurations: [Int] {
        guard let data = flightsResponse.data else {
            return []
        }
        
        let allFlights = data.bestFlights + data.otherFlights
        return allFlights.map { $0.totalDuration }
    }
    
    var flightPrices: [Int] {
        guard let data = flightsResponse.data else {
            return []
        }
        
        let allFlights = data.bestFlights + data.otherFlights
        return allFlights.map { $0.price }
    }
    
    var filteredFlights: [FlightItem] {
        guard let data = flightsResponse.data else {
            print("returning none")
            return []
        }
        
        let allFlights = data.bestFlights + data.otherFlights
        
        let filteredByAirline = allFlights.filter { flightItem in
            guard let firstFlight = flightItem.flights.first else { return false }
            return airlineFilter[firstFlight.airline]?.isEnabled == true
        }
        
        let filteredByStops: [FlightItem]
        switch stopsFilter {
        case .any:
            filteredByStops = filteredByAirline
        case .nonstop:
            filteredByStops = filteredByAirline.filter { $0.flights.count == 1 }
        case .oneOrLess:
            filteredByStops = filteredByAirline.filter { $0.flights.count <= 2 }
        case .twoOrLess:
            filteredByStops = filteredByAirline.filter { $0.flights.count <= 3 }
        }
        
        let filteredByDuration = filteredByStops.filter { $0.totalDuration <= durationFilter }
        
        let filteredByPrice = filteredByDuration.filter { $0.price <= priceFilter }
        
        switch sortFlightsMethod {
        case .cheapest:
            return filteredByPrice.sorted { $0.price < $1.price }
        case .mostExpensive:
            return filteredByPrice.sorted { $0.price > $1.price }
        case .quickest:
            return filteredByPrice.sorted { $0.totalDuration < $1.totalDuration }
        case .earliest:
            return filteredByPrice.sorted {
                guard let firstFlightA = $0.flights.first,
                      let firstFlightB = $1.flights.first else { return false }
                return firstFlightA.arrivalAirport.time < firstFlightB.arrivalAirport.time
            }
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
