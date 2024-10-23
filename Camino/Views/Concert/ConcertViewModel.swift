import Foundation

class ConcertViewModel: ObservableObject {
    var concert: Concert
    
    @Published var tripStartDate: Date
    @Published var tripEndDate: Date
    @Published var flightsResponse: ApiResponse<FlightsResponse> = ApiResponse<FlightsResponse>()
    
    init(concert: Concert) {
        self.concert = concert
        
        let calendar = Calendar.current
        self.tripStartDate = calendar.date(byAdding: .day, value: -1, to: concert.dateTime) ?? Date()
        self.tripEndDate = calendar.date(byAdding: .day, value: 1, to: concert.dateTime) ?? Date()
    }
    
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
    
    func getFlights() async {
        self.flightsResponse = ApiResponse(status: .loading)
        
        do {
            let fetchedFlights = try await fetchDepartureFlights(lat: concert.latitude,
                                                                long: concert.longitude,
                                                                fromAirport: homeAirport,
                                                                fromDate: tripStartDate.traditionalFormat(),
                                                                toDate: tripEndDate.traditionalFormat())
            
            DispatchQueue.main.async {
                self.flightsResponse = ApiResponse(status: .success, data: fetchedFlights)
            }
        } catch {
            print("Error fetching flights: \(error)")
            DispatchQueue.main.async {
                self.flightsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
}
