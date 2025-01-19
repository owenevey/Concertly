import Foundation
import SwiftUI

class ConcertViewModel: TripViewModelProtocol {
    var concert: Concert
    
    @Published var tripStartDate: Date
    @Published var tripEndDate: Date
    @Published var flightsResponse: ApiResponse<FlightsResponse> = ApiResponse<FlightsResponse>()
    @Published var hotelsResponse: ApiResponse<HotelsResponse> = ApiResponse<HotelsResponse>()
    @Published var flightsPrice: Int = 0
    @Published var hotelsPrice: Int = 0
    @Published var cityName: String = ""
    
    init(concert: Concert) {
        self.concert = concert
        
        let calendar = Calendar.current
        self.tripStartDate = calendar.date(byAdding: .day, value: -1, to: concert.dateTime) ?? Date()
        self.tripEndDate = calendar.date(byAdding: .day, value: 1, to: concert.dateTime) ?? Date()
        self.cityName = concert.cityName
    }
    
    var totalPrice: Int {
        hotelsPrice + flightsPrice
    }
    
    func getDepartingFlights() async {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.flightsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedFlights = try await fetchDepartureFlights(lat: concert.latitude,
                                                                 long: concert.longitude,
                                                                 fromAirport: homeAirport,
                                                                 fromDate: tripStartDate.traditionalFormat(),
                                                                 toDate: tripEndDate.traditionalFormat())
            
            withAnimation(.easeInOut(duration: 0.3)) {
                self.flightsResponse = ApiResponse(status: .success, data: fetchedFlights)
                self.flightsPrice = fetchedFlights.bestFlights.first?.price ?? 0
            }
            
            let airlineLogoURLs: [URL] = (fetchedFlights.bestFlights + fetchedFlights.otherFlights).compactMap { flightItem in
                flightItem.flights.compactMap { flight in
                    URL(string: flight.airlineLogo)
                }
            }.flatMap { $0 }

            let uniqueAirlineLogoURLs = Array(Set(airlineLogoURLs))

            ImagePrefetcher.instance.startPrefetching(urls: uniqueAirlineLogoURLs)
            
        } catch {
            print("Error fetching flights: \(error)")
            withAnimation(.easeInOut(duration: 0.3)) {
                self.flightsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getHotels() async {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.hotelsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedHotels = try await fetchHotels(location: concert.cityName,
                                                      fromDate: tripStartDate.traditionalFormat(),
                                                      toDate: tripEndDate.traditionalFormat())
            withAnimation(.easeInOut(duration: 0.3)) {
                self.hotelsResponse = ApiResponse(status: .success, data: fetchedHotels)
                self.hotelsPrice = fetchedHotels.properties.first?.totalRate.extractedLowest ?? 0
            }
            
            let hotelPhotos: [URL] = fetchedHotels.properties.compactMap { hotel in
                if let urlString = hotel.images?.first?.originalImage {
                    return URL(string: urlString)
                }
                return nil
            }
            
            ImagePrefetcher.instance.startPrefetching(urls: hotelPhotos)
            
        } catch {
            print("Error fetching hotels: \(error)")
            withAnimation(.easeInOut(duration: 0.3)) {
                self.hotelsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
}
