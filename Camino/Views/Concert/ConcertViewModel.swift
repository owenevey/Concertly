import Foundation

class ConcertViewModel: ObservableObject {
    var concert: Concert
    
    @Published var tripStartDate: Date
    @Published var tripEndDate: Date
    @Published var flightsResponse: ApiResponse<FlightInfo> = ApiResponse<FlightInfo>()
    @Published var fromAirport: String = homeAirport
    @Published var toAirport: String = ""
    
    var flightsPrice: Int {
        flightsResponse.data?.bestFlights.first?.price ?? 0
    }
    
    var hotelPrice: Int {
        270
    }
    
    var ticketPrice: Int {
        Int(concert.minPrice)
    }
    
    var totalPrice: Int {
        ticketPrice + hotelPrice + flightsPrice
    }
    
    init(concert: Concert) {
        self.concert = concert
        
        let calendar = Calendar.current
        self.tripStartDate = calendar.date(byAdding: .day, value: -1, to: concert.dateTime) ?? Date()
        self.tripEndDate = calendar.date(byAdding: .day, value: 1, to: concert.dateTime) ?? Date()
    }
    
    func getFlights() async {
        do {
            let fetchedFlights = try await fetchFlights(lat: concert.latitude,
                                                        long: concert.longitude,
                                                        fromAirport: fromAirport,
                                                        fromDate: tripStartDate.traditionalFormat(),
                                                        toDate: tripEndDate.traditionalFormat())
            
            DispatchQueue.main.async {
                self.flightsResponse = ApiResponse(status: .success, data: fetchedFlights.data)
                self.toAirport = fetchedFlights.data?.airports.first?.arrival.first?.airport.id ?? ""
            }
        } catch {
            print("Error fetching flights: \(error)")
            DispatchQueue.main.async {
                self.flightsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
}
