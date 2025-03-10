import Foundation
import Combine
import SwiftUI

@MainActor
final class FlightsViewModel<T: TripViewModelProtocol>: ObservableObject {
    
    @ObservedObject var tripViewModel: T
    @Published var fromDate: Date
    @Published var toDate: Date
    
    @Published var fromAirport: String
    @Published var toAirport: String
    
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
    
    private var cancellables = Set<AnyCancellable>()
    private var combinedPublisher: AnyPublisher<(Date, Date, String, String), Never>?
    
    // Ignores the first emission of each sink
    private var isFirstEmissionSink1 = true
    private var isFirstEmissionSink2 = true
        
    init(tripViewModel: T, fromDate: Date, toDate: Date, flightsResponse: ApiResponse<FlightsResponse>) {
        self.tripViewModel = tripViewModel
        self.fromDate = fromDate
        self.toDate = toDate
        self.fromAirport = UserDefaults.standard.string(forKey: AppStorageKeys.homeAirport.rawValue) ?? "JFK"
        self.toAirport = flightsResponse.data?.airports.first?.arrival.first?.airport.id ?? tripViewModel.closestAirport
        self.flightsResponse = flightsResponse
        self.priceInsights = flightsResponse.data?.priceInsights
        
        if flightsResponse.status == .empty {
            Task {
                await getDepartingFlights()
            }
        }
        
        resetFilters()
        setupCombineLatest()
    }
    
    private func setupCombineLatest() {
        combinedPublisher = Publishers.CombineLatest4($fromDate, $toDate, $fromAirport, $toAirport)
            .eraseToAnyPublisher()
        
        combinedPublisher?
            .removeDuplicates { (lhs, rhs) in
                return lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2 && lhs.3 == rhs.3
            }
            .filter { [weak self] _ in
                guard let self = self else { return false }
                if self.isFirstEmissionSink1 {
                    self.isFirstEmissionSink1 = false
                    return false
                }
                return true
            }
            .sink { [weak self] (fromDate, toDate, fromAirport, toAirport) in
                self?.tripViewModel.tripStartDate = fromDate
                self?.tripViewModel.tripEndDate = toDate
                
                if self?.fromDate != fromDate || self?.toDate != toDate {
                    Task {
                        await self?.getDepartingFlights()
                        if self?.tripViewModel.hotelsResponse.status != .empty {
                            await self?.tripViewModel.getHotels()
                        }
                    }
                }
                else if !(self?.toAirport == "" && toAirport != "") {
                    Task {
                        await self?.getDepartingFlights()
                    }
                }
            }
            .store(in: &cancellables)
        
        $departingFlight
            .removeDuplicates()
            .filter { [weak self] _ in
                guard let self = self else { return false }
                if self.isFirstEmissionSink2 {
                    self.isFirstEmissionSink2 = false
                    return false
                }
                return true
            }
            .sink { [weak self] departingFlight in
                if departingFlight != nil {
                    Task {
                        await self?.getReturningFlights()
                    }
                } else {
                    Task {
                        await self?.getDepartingFlights()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func resetFilters() {
        if let data = flightsResponse.data {
            self.sortFlightsMethod = .recommended
            
            let prices = data.flights.map { $0.price }
            self.priceFilter = prices.max() ?? Int.max
            
            let durations = data.flights.map { $0.totalDuration }
            self.durationFilter = durations.max() ?? Int.max
            
            let arrivalTimes = data.flights.compactMap { flightItem in
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
        
        return data.flights.map { $0.price }
    }
    
    var flightDurations: [Int] {
        guard let data = flightsResponse.data else {
            return []
        }
        
        return data.flights.compactMap { $0.totalDuration }
    }
    
    var flightArrivalTimes: [Int] {
        guard let data = flightsResponse.data else {
            return []
        }
        return data.flights.compactMap { flightItem in
            flightItem.flights.last?.arrivalAirport.time.timeIntervalSince1970
        }.map { Int($0) / 60 }
    }
    
    var filteredFlights: [FlightItem] {
        guard let data = flightsResponse.data else {
            print("No flightsResponse data")
            return []
        }
        
        return data.flights
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
        
        for flightItem in flights.flights {
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
            var fetchedFlights = ApiResponse<FlightsResponse>()
            if toAirport != "" {
                fetchedFlights = try await fetchDepartureFlights(fromAirport: fromAirport,
                                                                     toAirport: toAirport,
                                                                     fromDate: fromDate.EuropeanFormat(),
                                                                     toDate: toDate.EuropeanFormat())
            } else {
                fetchedFlights = try await fetchDepartureFlights(fromAirport: fromAirport,
                                                                 lat: tripViewModel.latitude,
                                                                 long: tripViewModel.longitude,
                                                                 fromDate: fromDate.EuropeanFormat(),
                                                                 toDate: toDate.EuropeanFormat())
            }
            
            if let retrievedFlights = fetchedFlights.data {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.flightsResponse = ApiResponse(status: .success, data: retrievedFlights)
                    self.tripViewModel.flightsResponse = ApiResponse(status: .success, data: retrievedFlights)
                    self.toAirport = flightsResponse.data?.airports.first?.arrival.first?.airport.id ?? ""
                    self.tripViewModel.flightsPrice = retrievedFlights.flights.last?.price ?? 0
                    self.priceInsights = retrievedFlights.priceInsights
                    self.resetFilters()
                }
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.flightsResponse = ApiResponse(status: .error, error: fetchedFlights.error ?? "Couldn't fetch flights")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.flightsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getReturningFlights() async {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.flightsResponse = ApiResponse(status: .loading)
            self.resetFilters()
        }
        
        do {
            guard let departureToken = departingFlight?.departureToken else {
                throw ConcertlyError.missingDepartureToken
            }
            let fetchedFlights = try await fetchReturnFlights(fromAirport: fromAirport,
                                                              toAirport: toAirport,
                                                              fromDate: fromDate.EuropeanFormat(),
                                                              toDate: toDate.EuropeanFormat(),
                                                              departureToken: departureToken)
            
            if departingFlight == nil {
                return
            }
            
            if let retrievedFlights = fetchedFlights.data {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.flightsResponse = ApiResponse(status: .success, data: retrievedFlights)
                    self.resetFilters()
                }
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.flightsResponse = ApiResponse(status: .error, error: fetchedFlights.error ?? "Couldn't fetch flights")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.flightsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
}
