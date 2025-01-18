import Foundation
import SwiftUI

@MainActor
final class FlightsViewModel: ObservableObject {
    
    @Published var fromDate: Date
    @Published var toDate: Date
    
    @Published var fromAirport = homeAirport
    @Published var toAirport: String = ""
    
    @Published var flightsResponse: ApiResponse<FlightsResponse>
    @Published var priceInsights: PriceInsights?
    
    @Published var sortFlightsMethod = SortFlightsEnum.recommended
    @Published var airlineFilter: [String: (imageURL: String, isEnabled: Bool)] = [:]
    @Published var stopsFilter: FilterStopsEnum = .any
    @Published var priceFilter: Int = Int.max
    @Published var durationFilter: Int = Int.max
    @Published var arrivalTimeFilter: Int = Int.max
    
    @Published var departingFlight: FlightItem?
    @Published var returningFlight: FlightItem?
    
    init(fromDate: Date, toDate: Date, flightsResponse: ApiResponse<FlightsResponse>) {
        self.fromDate = fromDate
        self.toDate = toDate
        self.toAirport = flightsResponse.data?.airports.first?.arrival.first?.airport.id ?? ""
        self.flightsResponse = flightsResponse
        self.priceInsights = flightsResponse.data?.priceInsights
        
        resetFilters()
    }
    
    func resetFilters() {
        if let data = flightsResponse.data {
            self.sortFlightsMethod = .recommended
            let allFlights = data.bestFlights + data.otherFlights
            
            let prices = allFlights.map { $0.price }
            self.priceFilter = prices.max() ?? Int.max
            
            let durations = allFlights.map { $0.totalDuration }
            self.durationFilter = durations.max() ?? Int.max
            
            let arrivalTimes = allFlights.compactMap { flightItem in
                flightItem.flights.last?.arrivalAirport.time.timeIntervalSince1970
            }
            self.arrivalTimeFilter = Int((arrivalTimes.max() ?? 0) / 60)
            if self.arrivalTimeFilter == 0 {
                self.arrivalTimeFilter = Int.max
            }
            
            self.airlineFilter = extractAirlineData(from: flightsResponse.data)
        } else {
            self.sortFlightsMethod = .recommended
            self.priceFilter = Int.max
            self.durationFilter = Int.max
            self.arrivalTimeFilter = Int.max
        }
    }
    
    var flightPrices: [Int] {
        guard let data = flightsResponse.data else {
            return []
        }
        
        let allFlights = data.bestFlights + data.otherFlights
        return allFlights.map { $0.price }
    }
    
    var flightDurations: [Int] {
        guard let data = flightsResponse.data else {
            return []
        }
        
        let allFlights = data.bestFlights + data.otherFlights
        return allFlights.map { $0.totalDuration }
    }
    
    var flightArrivalTimes: [Int] {
        guard let data = flightsResponse.data else {
            return []
        }
        
        let allFlights = data.bestFlights + data.otherFlights
        return allFlights.compactMap { flightItem in
            flightItem.flights.last?.arrivalAirport.time.timeIntervalSince1970
        }.map { Int($0) / 60 }
    }
    
    var filteredFlights: [FlightItem] {
        guard let data = flightsResponse.data else {
            print("No flightsResponse data")
            return []
        }
        
        let allFlights = data.bestFlights + data.otherFlights
        return allFlights
            .filter { flightItem in
                return flightItem.flights.allSatisfy { flight in
                        airlineFilter[flight.airline]?.isEnabled == true
                    }
            }
            .filter {
                switch stopsFilter {
                case .any: return true
                case .nonstop: return $0.flights.count == 1
                case .oneOrLess: return $0.flights.count <= 2
                case .twoOrLess: return $0.flights.count <= 3
                }
            }
            .filter { $0.price <= priceFilter }
            .filter { $0.totalDuration <= durationFilter }
            .filter { flightItem in
                guard let lastFlight = flightItem.flights.last else { return false }
                let arrivalTime = Int(lastFlight.arrivalAirport.time.timeIntervalSince1970) / 60
                return arrivalTime <= arrivalTimeFilter
            }
            .sorted {
                switch sortFlightsMethod {
                case .recommended:
                    return true
                case .cheapest:
                    return $0.price < $1.price
                case .mostExpensive:
                    return $0.price > $1.price
                case .quickest:
                    return $0.totalDuration < $1.totalDuration
                case .earliest:
                    guard let flightA = $0.flights.last,
                          let flightB = $1.flights.last else { return false }
                    return flightA.arrivalAirport.time < flightB.arrivalAirport.time
                }
            }
    }
    
    func extractAirlineData(from flightData: FlightsResponse?) -> [String: (imageURL: String, isEnabled: Bool)] {
        var airlineDict: [String: (imageURL: String, isEnabled: Bool)] = [:]
        
        guard let flights = flightData else {
            return airlineDict
        }
        
        let allFlights = flights.bestFlights + flights.otherFlights
        
        for flightItem in allFlights {
            for flight in flightItem.flights {
                let airlineName = flight.airline
                let airlineLogo = flight.airlineLogo
                
                if airlineDict[airlineName] == nil {
                    airlineDict[airlineName] = (imageURL: airlineLogo, isEnabled: true)
                }
            }
        }
        
        return airlineDict
    }
    
    func getDepartingFlights() async {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.departingFlight = nil
            self.flightsResponse = ApiResponse(status: .loading)
            self.resetFilters()
        }
        
        do {
            try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
            let fetchedFlights = try await fetchDepartureFlights(fromAirport: homeAirport,
                                                                 toAirport: toAirport,
                                                                 fromDate: fromDate.traditionalFormat(),
                                                                 toDate: toDate.traditionalFormat())
            withAnimation(.easeInOut(duration: 0.3)) {
                self.flightsResponse = ApiResponse(status: .success, data: fetchedFlights)
                self.priceInsights = fetchedFlights.priceInsights
                self.resetFilters()
            }
        } catch {
            print("Error fetching flights: \(error)")
            withAnimation(.easeInOut(duration: 0.3)) {
                self.flightsResponse = ApiResponse(status: .error, error: error.localizedDescription)
                self.resetFilters()
            }
        }
    }
    
    func getReturningFlights() async {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.flightsResponse = ApiResponse(status: .loading)
            self.resetFilters()
        }
        
        do {
            try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
            guard let departureToken = departingFlight?.departureToken else {
                throw CaminoError.missingDepartureToken
            }
            
            let fetchedFlights = try await fetchReturnFlights(fromAirport: homeAirport,
                                                              toAirport: toAirport,
                                                              fromDate: fromDate.traditionalFormat(),
                                                              toDate: toDate.traditionalFormat(), departureToken: departureToken)
            
            withAnimation(.easeInOut(duration: 0.3)) {
                self.flightsResponse = ApiResponse(status: .success, data: fetchedFlights)
                self.resetFilters()
            }
        } catch {
            print("Error fetching flights: \(error)")
            withAnimation(.easeInOut(duration: 0.3)) {
                self.flightsResponse = ApiResponse(status: .error, error: error.localizedDescription)
                self.resetFilters()
            }
        }
    }
}
