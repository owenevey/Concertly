import Foundation
import SwiftUI

class PlaceViewModel: TripViewModelProtocol {
    var place: Place
    
    @Published var tripStartDate: Date
    @Published var tripEndDate: Date
    @Published var flightsResponse: ApiResponse<FlightsResponse> = ApiResponse<FlightsResponse>()
    @Published var hotelsResponse: ApiResponse<HotelsResponse> = ApiResponse<HotelsResponse>()
    @Published var flightsPrice: Int = 0
    @Published var hotelsPrice: Int = 0
    @Published var cityName: String = ""
    
    init(place: Place) {
        self.place = place
        
        let calendar = Calendar.current
        self.tripStartDate = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        self.tripEndDate = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        self.cityName = place.cityName
    }

    
    var totalPrice: Int {
        hotelsPrice + flightsPrice
    }
    
    func getDepartingFlights() async {
        self.flightsResponse = ApiResponse(status: .loading)
        
        do {
            let fetchedFlights = try await fetchDepartureFlights(lat: place.latitude,
                                                                 long: place.longitude,
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
            let fetchedHotels = try await fetchHotels(location: place.name,
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
