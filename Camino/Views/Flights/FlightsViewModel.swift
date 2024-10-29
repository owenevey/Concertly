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
    
    init(fromDate: Date, toDate: Date, flightsResponse: ApiResponse<FlightsResponse>) {
        self.fromDate = fromDate
        self.toDate = toDate
        self.flightsResponse = flightsResponse
        
        if let data = flightsResponse.data {
            let allFlights = data.bestFlights + data.otherFlights
            let durations = allFlights.map { $0.totalDuration }
            self.durationFilter = durations.max() ?? 0
        } else {
            self.durationFilter = 0
        }
    }
    
    var durationRange: DurationRange {
            if let data = flightsResponse.data {
                let allFlights = data.bestFlights + data.otherFlights
                let minDuration = allFlights.map { $0.totalDuration }.min() ?? 0
                let maxDuration = allFlights.map { $0.totalDuration }.max() ?? 0
                return DurationRange(min: minDuration, max: maxDuration)
            } else {
                return DurationRange(min: 0, max: 0)
            }
        }
    
    var filteredFlights: [FlightItem] {
            guard let data = flightsResponse.data else {
                print("returning none")
                return []
            }
            
            let allFlights = data.bestFlights + data.otherFlights
            
            // Filter by airline
            let filteredByAirline = allFlights.filter { flightItem in
                guard let firstFlight = flightItem.flights.first else { return false }
                return airlineFilter[firstFlight.airline]?.isEnabled == true
            }
            
            // Filter by stops
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

            // Filter by duration
            let filteredByDuration = filteredByStops.filter { $0.totalDuration <= durationFilter }

            // Step 3: Sort based on sort method
            switch sortFlightsMethod {
            case .cheapest:
                return filteredByDuration.sorted { $0.price < $1.price }
            case .mostExpensive:
                return filteredByDuration.sorted { $0.price > $1.price }
            case .quickest:
                return filteredByDuration.sorted { $0.totalDuration < $1.totalDuration }
            case .earliest:
                return filteredByDuration.sorted {
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
