import Foundation
import SwiftUI

class VenueViewModel: TripViewModelProtocol {
    var venue: Venue
    
    let latitude: Double
    let longitude: Double
    var closestAirport: String
    
    @Published var tripStartDate: Date
    @Published var tripEndDate: Date
    @Published var concertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var flightsResponse: ApiResponse<FlightsResponse> = ApiResponse<FlightsResponse>()
    @Published var hotelsResponse: ApiResponse<HotelsResponse> = ApiResponse<HotelsResponse>()
    @Published var flightsPrice: Int = 0
    @Published var hotelsPrice: Int = 0
    @Published var cityName: String = ""
    
    let homeAirport: String
    
    init(venue: Venue) {
        self.venue = venue
        self.cityName = venue.cityName
        self.latitude = venue.latitude
        self.longitude = venue.longitude
        self.closestAirport = venue.closestAirport
        
        let calendar = Calendar.current
        self.tripStartDate = calendar.date(byAdding: .day, value: 21, to: Date()) ?? Date()
        self.tripEndDate = calendar.date(byAdding: .day, value: 25, to: Date()) ?? Date()
        
        self.homeAirport = UserDefaults.standard.string(forKey: AppStorageKeys.homeAirport.rawValue) ?? "JFK"
        
        Task {
            await getConcerts()
        }
    }
    
    var totalPrice: Int {
        hotelsPrice + flightsPrice
    }
    
    func getConcerts() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.concertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcerts = try await fetchConcertsForVenue(venueId: venue.id)
            
            if let concerts = fetchedConcerts.data?.concerts {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.concertsResponse = ApiResponse(status: .success, data: concerts)
                }
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.concertsResponse = ApiResponse(status: .error, error: "Couldn't fetch concerts")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.concertsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func getDepartingFlights() async {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.flightsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedFlights = try await fetchDepartureFlights(fromAirport: homeAirport,
                                                                 toAirport: venue.closestAirport,
                                                                 fromDate: tripStartDate.EuropeanFormat(),
                                                                 toDate: tripEndDate.EuropeanFormat())
            
            if let retrievedFlights = fetchedFlights.data {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.flightsResponse = ApiResponse(status: .success, data: retrievedFlights)
                    self.flightsPrice = retrievedFlights.flights.first?.price ?? 0
                }
                
                let airlineLogoURLs: [URL] = (retrievedFlights.flights).compactMap { flightItem in
                    flightItem.flights.compactMap { flight in
                        URL(string: flight.airlineLogo)
                    }
                }.flatMap { $0 }

                let uniqueAirlineLogoURLs = Array(Set(airlineLogoURLs))

                ImagePrefetcher.shared.startPrefetching(urls: uniqueAirlineLogoURLs)
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.flightsResponse = ApiResponse(status: .error, error: "Couldn't fetch flights")
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
            let fetchedHotels = try await fetchHotels(location: venue.cityName,
                                                      fromDate: tripStartDate.traditionalFormat(),
                                                      toDate: tripEndDate.traditionalFormat())
            
            
            if let retrievedHotels = fetchedHotels.data {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.hotelsResponse = ApiResponse(status: .success, data: retrievedHotels)
                    self.hotelsPrice = retrievedHotels.properties.first?.totalRate?.extractedLowest ?? 0
                }
                
                let hotelPhotos: [URL] = retrievedHotels.properties.compactMap { hotel in
                    if let urlString = hotel.images?.first?.originalImage {
                        return URL(string: urlString)
                    }
                    return nil
                }
                
                ImagePrefetcher.shared.startPrefetching(urls: hotelPhotos)
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
