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
        self.tripStartDate = calendar.date(byAdding: .day, value: -1, to: concert.date) ?? Date()
        self.tripEndDate = calendar.date(byAdding: .day, value: 1, to: concert.date) ?? Date()
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
            var fetchedFlights = ApiResponse<FlightsResponse>()
            if let destinationAirport = concert.closestAirport {
                fetchedFlights = try await fetchDepartureFlights(fromAirport: homeAirport,
                                                                 toAirport: destinationAirport,
                                                                 fromDate: tripStartDate.EuropeanFormat(),
                                                                 toDate: tripEndDate.EuropeanFormat())
            } else {
                fetchedFlights = try await fetchDepartureFlights(fromAirport: homeAirport,
                                                                 lat: concert.latitude,
                                                                 long: concert.longitude,
                                                                 fromDate: tripStartDate.EuropeanFormat(),
                                                                 toDate: tripEndDate.EuropeanFormat())
            }
            
            if let retrievedFlights = fetchedFlights.data {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.flightsResponse = ApiResponse(status: .success, data: retrievedFlights)
                    self.flightsPrice = retrievedFlights.flights.last?.price ?? 0
                }
                
                let airlineLogoURLs: [URL] = (retrievedFlights.flights).compactMap { flightItem in
                    flightItem.flights.compactMap { flight in
                        URL(string: flight.airlineLogo)
                    }
                }.flatMap { $0 }
                
                let uniqueAirlineLogoURLs = Array(Set(airlineLogoURLs))
                
                ImagePrefetcher.instance.startPrefetching(urls: uniqueAirlineLogoURLs)
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
    
    func getHotels() async {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.hotelsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedHotels = try await fetchHotels(location: concert.cityName,
                                                      fromDate: tripStartDate.EuropeanFormat(),
                                                      toDate: tripEndDate.EuropeanFormat())
            
            
            if let retrievedHotels = fetchedHotels.data {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.hotelsResponse = ApiResponse(status: .success, data: retrievedHotels)
                    self.hotelsPrice = retrievedHotels.properties.first?.totalRate.extractedLowest ?? 0
                }
                
                let hotelPhotos: [URL] = retrievedHotels.properties.compactMap { hotel in
                    if let urlString = hotel.images?.first?.originalImage {
                        return URL(string: urlString)
                    }
                    return nil
                }
                
                ImagePrefetcher.instance.startPrefetching(urls: hotelPhotos)
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.hotelsResponse = ApiResponse(status: .error, error: fetchedHotels.error ?? "Couldn't fetch hotels")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.hotelsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
}
