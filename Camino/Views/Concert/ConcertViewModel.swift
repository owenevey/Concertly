import Foundation
import SwiftUI

@MainActor
class ConcertViewModel: ObservableObject {
    var concert: Concert
    
    @Published var tripStartDate: Date
    @Published var tripEndDate: Date
    @Published var flightsResponse: ApiResponse<FlightsResponse> = ApiResponse<FlightsResponse>()
    @Published var hotelsResponse: ApiResponse<HotelsResponse> = ApiResponse<HotelsResponse>()
    @Published var flightsPrice: Int = 0
    @Published var hotelsPrice: Int = 0
    
    init(concert: Concert) {
        self.concert = concert
        
        let calendar = Calendar.current
        self.tripStartDate = calendar.date(byAdding: .day, value: -1, to: concert.dateTime) ?? Date()
        self.tripEndDate = calendar.date(byAdding: .day, value: 1, to: concert.dateTime) ?? Date()
    }
    
    var ticketPrice: Int {
        Int(concert.minPrice)
    }
    
    var totalPrice: Int {
        ticketPrice + hotelsPrice + flightsPrice
    }
    
    func getDepartingFlights() async {
        self.flightsResponse = ApiResponse(status: .loading)
        
        do {
            try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
            let fetchedFlights = try await fetchDepartureFlights(lat: concert.latitude,
                                                                 long: concert.longitude,
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
            try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
            let fetchedHotels = try await fetchHotels(location: concert.generalLocation,
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
