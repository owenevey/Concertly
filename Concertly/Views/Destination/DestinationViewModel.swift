import Foundation
import SwiftUI

class DestinationViewModel: TripViewModelProtocol {
    var destination: Destination
    
    @Published var tripStartDate: Date
    @Published var tripEndDate: Date
    @Published var concertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var flightsResponse: ApiResponse<FlightsResponse> = ApiResponse<FlightsResponse>()
    @Published var hotelsResponse: ApiResponse<HotelsResponse> = ApiResponse<HotelsResponse>()
    @Published var flightsPrice: Int = 0
    @Published var hotelsPrice: Int = 0
    @Published var cityName: String = ""
    
    let homeAirport: String
    
    init(destination: Destination) {
        self.destination = destination
        self.cityName = destination.cityName
        
        let calendar = Calendar.current
        self.tripStartDate = calendar.date(byAdding: .day, value: 21, to: Date()) ?? Date()
        self.tripEndDate = calendar.date(byAdding: .day, value: 25, to: Date()) ?? Date()
        
        self.homeAirport = UserDefaults.standard.string(forKey: "Home Airport") ?? "JFK"
        
        Task {
            await getConcerts()
            await getDepartingFlights()
            await getHotels()
        }
        let destinationUrls = destination.images.compactMap { return URL(string: $0) }
        ImagePrefetcher.instance.startPrefetching(urls: destinationUrls)
    }
    
    var totalPrice: Int {
        hotelsPrice + flightsPrice
    }
    
    func getConcerts() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.concertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcerts = try await fetchConcertsForDestination(lat: destination.latitude, long: destination.longitude)
            
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
                                                                 toAirport: destination.closestAirport,
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

                ImagePrefetcher.instance.startPrefetching(urls: uniqueAirlineLogoURLs)
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.flightsResponse = ApiResponse(status: .error, error: "Couldn't fetch flights")
                }
            }
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
            let fetchedHotels = try await fetchHotels(location: destination.cityName,
                                                      fromDate: tripStartDate.EuropeanFormat(),
                                                      toDate: tripEndDate.EuropeanFormat())
            
            
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
