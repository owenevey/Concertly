import Foundation
import SwiftUI

final class FlightsViewModel: ObservableObject {
    
    @Published var fromDate: Date
    @Published var toDate: Date
    
    @Published var fromAirport = homeAirport
    @Published var toAirport: String = ""
    
    @Published var flightsResponse: ApiResponse<FlightsResponse>
    
    @Published var sortFlightsMethod = SortFlightsEnum.recommended
    @Published var airlineFilter: [String: (imageURL: String, isEnabled: Bool)] = [:]
    @Published var stopsFilter: FilterStopsEnum = .any
    @Published var priceFilter: Int = Int.max
    @Published var durationFilter: Int = Int.max
    @Published var timeFilter: Int = Int.max
    
    @Published var departingFlight: FlightItem?
    @Published var returningFlight: FlightItem?
    
    init(fromDate: Date, toDate: Date, flightsResponse: ApiResponse<FlightsResponse>) {
        self.fromDate = fromDate
        self.toDate = toDate
        self.flightsResponse = flightsResponse
        
        resetFilters()
    }
    
    func resetFilters() {
        print("tehe", flightsResponse)
        if let data = flightsResponse.data {
            print("if block")
            self.toAirport = data.airports.first!.arrival.first!.airport.id
            
            let allFlights = data.bestFlights + data.otherFlights
            
            let prices = allFlights.map { $0.price }
            self.priceFilter = prices.max() ?? Int.max
            
            let durations = allFlights.map { $0.totalDuration }
            self.durationFilter = durations.max() ?? Int.max
            
            let arrivalTimes = allFlights.compactMap { flightItem in
                flightItem.flights.last?.arrivalAirport.time.timeIntervalSince1970
            }
            self.timeFilter = Int((arrivalTimes.max() ?? 0) / 60)
            
            self.airlineFilter = extractAirlineData(from: flightsResponse.data)
        } else {
            print("else block")
            self.priceFilter = Int.max
            self.durationFilter = Int.max
            self.timeFilter = Int.max
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
    
    var flightTimes: [Int] {
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
            print("no flightsResponse data")
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
        
        let filteredByPrice = filteredByStops.filter { $0.price <= priceFilter }
        
        let filteredByDuration = filteredByPrice.filter { $0.totalDuration <= durationFilter }
        
        let filteredByTime = filteredByDuration.filter { flightItem in
            guard let firstFlight = flightItem.flights.first else { return false }
            let arrivalTime = Int(firstFlight.arrivalAirport.time.timeIntervalSince1970) / 60
            return arrivalTime <= timeFilter
        }
        
        switch sortFlightsMethod {
        case .recommended:
            return filteredByTime
        case .cheapest:
            return filteredByTime.sorted { $0.price < $1.price }
        case .mostExpensive:
            return filteredByTime.sorted { $0.price > $1.price }
        case .quickest:
            return filteredByTime.sorted { $0.totalDuration < $1.totalDuration }
        case .earliest:
            return filteredByTime.sorted {
                guard let firstFlightA = $0.flights.first,
                      let firstFlightB = $1.flights.first else { return false }
                return firstFlightA.arrivalAirport.time < firstFlightB.arrivalAirport.time
            }
        }
    }
    
    
    
    func extractAirlineData(from flightData: FlightsResponse?) -> [String: (imageURL: String, isEnabled: Bool)] {
        var airlineDict: [String: (imageURL: String, isEnabled: Bool)] = [:]
        
        guard let flights = flightData else {
            return airlineDict
        }
        
        // Loop through all the best flights
        for flightItem in flights.bestFlights {
            // Loop through the individual flights in each item
            for flight in flightItem.flights {
                let airlineName = flight.airline
                let airlineLogo = flight.airlineLogo
                
                // If the airline doesn't already exist in the dictionary, add it
                if airlineDict[airlineName] == nil {
                    airlineDict[airlineName] = (imageURL: airlineLogo, isEnabled: true)
                }
            }
        }
        
        for flightItem in flights.otherFlights {
            // Loop through the individual flights in each item
            for flight in flightItem.flights {
                let airlineName = flight.airline
                let airlineLogo = flight.airlineLogo
                
                // If the airline doesn't already exist in the dictionary, add it
                if airlineDict[airlineName] == nil {
                    airlineDict[airlineName] = (imageURL: airlineLogo, isEnabled: true)
                }
            }
        }
        
        return airlineDict
    }
    
    func getDepartingFlights() async {
        DispatchQueue.main.async {
            self.flightsResponse = ApiResponse(status: .loading)
            self.resetFilters()
        }
        
        
        do {
            let fetchedFlights = try await fetchDepartureFlights(fromAirport: homeAirport,
                                                                 toAirport: toAirport,
                                                                 fromDate: fromDate.traditionalFormat(),
                                                                 toDate: toDate.traditionalFormat())
            
            DispatchQueue.main.async {
                self.flightsResponse = ApiResponse(status: .success, data: fetchedFlights)
                self.resetFilters()
            }
        } catch {
            print("Error fetching flights: \(error)")
            DispatchQueue.main.async {
                self.flightsResponse = ApiResponse(status: .error, error: error.localizedDescription)
                self.resetFilters()
            }
        }
    }
    
    func getReturningFlights() async {
        DispatchQueue.main.async {
            self.flightsResponse = ApiResponse(status: .loading)
            self.resetFilters()
        }
        
        do {
            let fetchedFlights = try await fetchReturnFlights(fromAirport: homeAirport,
                                                              toAirport: toAirport,
                                                              fromDate: fromDate.traditionalFormat(),
                                                              toDate: toDate.traditionalFormat(), departureToken: departingFlight!.departureToken!)
            
            DispatchQueue.main.async {
                self.flightsResponse = ApiResponse(status: .success, data: fetchedFlights)
                self.resetFilters()
            }
        } catch {
            print("Error fetching flights: \(error)")
            DispatchQueue.main.async {
                self.flightsResponse = ApiResponse(status: .error, error: error.localizedDescription)
                self.resetFilters()
            }
        }
    }
}
