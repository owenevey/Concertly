import Foundation
import SwiftUI
import Combine

class ConcertViewModel: TripViewModelProtocol {
    var concert: Concert
    
    let latitude: Double
    let longitude: Double
    var closestAirport: String
    
    @Published var tripStartDate: Date
    @Published var tripEndDate: Date
    @Published var flightsResponse: ApiResponse<FlightsResponse> = ApiResponse<FlightsResponse>()
    @Published var hotelsResponse: ApiResponse<HotelsResponse> = ApiResponse<HotelsResponse>()
    @Published var flightsPrice: Int = -1
    @Published var hotelsPrice: Int = -1
    @Published var cityName: String = ""
    @Published var isSaved: Bool
    
    let homeAirport: String
    
    // Ignores the first emission of each sink
    private var isFirstEmissionSink1 = true
    private var isFirstEmissionSink2 = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init(concert: Concert) {
        self.concert = concert
        self.latitude = concert.latitude
        self.longitude = concert.longitude
        self.closestAirport = concert.closestAirport ?? ""
        
        let calendar = Calendar.current
        let calculatedStartDate = calendar.date(byAdding: .day, value: -2, to: concert.date) ?? Date()
        self.tripStartDate = max(calculatedStartDate, Date())
        
        self.tripEndDate = calendar.date(byAdding: .day, value: 1, to: concert.date) ?? Date()
        self.cityName = concert.cityName
        self.isSaved = CoreDataManager.shared.isConcertSaved(id: concert.id)
        
        self.homeAirport = UserDefaults.standard.string(forKey: AppStorageKeys.homeAirport.rawValue) ?? "JFK"
        
        setupBindings()
        
        Task {
            await SaveConcertTip.visitConcertEvent.donate()
        }
    }
    
    private func setupBindings() {
        $flightsPrice
            .filter { [weak self] _ in
                guard let self = self else { return false }
                if self.isFirstEmissionSink1 {
                    self.isFirstEmissionSink1 = false
                    return false
                }
                return true
            }
            .sink { [weak self] newPrice in
                guard let self = self else { return }
                self.concert.flightsPrice = newPrice
                if isSaved {
                    CoreDataManager.shared.saveConcert(self.concert)
                }
            }
            .store(in: &cancellables)
        
        $hotelsPrice
            .filter { [weak self] _ in
                guard let self = self else { return false }
                if self.isFirstEmissionSink2 {
                    self.isFirstEmissionSink2 = false
                    return false
                }
                return true
            }
            .sink { [weak self] newPrice in
                guard let self = self else { return }
                self.concert.hotelsPrice = newPrice
                if isSaved {
                    CoreDataManager.shared.saveConcert(self.concert)
                }
            }
            .store(in: &cancellables)
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
                
                ImagePrefetcher.shared.startPrefetching(urls: uniqueAirlineLogoURLs)
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
    
    func checkIfSaved() {
        isSaved = CoreDataManager.shared.isConcertSaved(id: concert.id)
    }
    
    func toggleConcertSaved() {
        if isSaved {
            CoreDataManager.shared.unSaveConcert(id: concert.id)
            
            NotificationManager.shared.removeConcertReminder(for: concert)
        }
        else {
            Task {
                await SaveConcertTip.saveConcertEvent.donate()
            }
            
            CoreDataManager.shared.saveConcert(concert)
            
            let concertRemindersPreference = UserDefaults.standard.integer(forKey: AppStorageKeys.concertReminders.rawValue)
            
            if concertRemindersPreference != 0 {
                NotificationManager.shared.scheduleConcertReminder(for: concert, daysBefore: concertRemindersPreference)
            }
        }
        
        isSaved.toggle()
    }
}
