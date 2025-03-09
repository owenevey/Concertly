import Foundation
import Combine
import SwiftUI

@MainActor
final class HotelsViewModel<T: TripViewModelProtocol>: ObservableObject {
    
    @ObservedObject var tripViewModel: T
    @Published var location: String
    @Published var fromDate: Date
    @Published var toDate: Date
    
    @Published var hotelsResponse: ApiResponse<HotelsResponse>
    
    @Published var sortMethod = SortHotelsEnum.recommended
    @Published var priceFilter: Int = Int.max
    @Published var ratingFilter: Int = 1
    @Published var locationRatingFilter: Int = 1
    
    @Published var selectedHotel: Property?
    
    private var cancellables = Set<AnyCancellable>()
    private var combinedPublisher: AnyPublisher<(Date, Date, String), Never>?
    private var isFirstEmissionSink = true
    
    
    init(tripViewModel: T, location: String, fromDate: Date, toDate: Date, hotelsResponse: ApiResponse<HotelsResponse>) {
        self.tripViewModel = tripViewModel
        self.location = location
        self.fromDate = fromDate
        self.toDate = toDate
        self.hotelsResponse = hotelsResponse
        
        if hotelsResponse.status == .empty {
            Task {
                await getHotels()
            }
        }
        
        resetFilters()
        setupCombineLatest()
    }
    
    private func setupCombineLatest() {
        combinedPublisher = Publishers.CombineLatest3($fromDate, $toDate, $location)
            .eraseToAnyPublisher()
        
        combinedPublisher?
            .removeDuplicates { (lhs, rhs) in
                return lhs.0 == rhs.0 && lhs.1 == rhs.1 && lhs.2 == rhs.2
            }
            .filter { [weak self] _ in
                guard let self = self else { return false }
                if self.isFirstEmissionSink {
                    self.isFirstEmissionSink = false
                    return false
                }
                return true
            }
            .sink { [weak self] (fromDate, toDate, location) in
                self?.tripViewModel.tripStartDate = fromDate
                self?.tripViewModel.tripEndDate = toDate
                
                if self?.fromDate != fromDate || self?.toDate != toDate {
                    Task {
                        await self?.getHotels()
                        if self?.tripViewModel.flightsResponse.status != .empty {
                            await self?.tripViewModel.getDepartingFlights()
                        }
                    }
                } else {
                    Task {
                        await self?.getHotels()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func resetFilters() {
        if let properties = hotelsResponse.data?.properties {
            
            self.sortMethod = .recommended
            
            let prices = properties.compactMap { $0.totalRate?.extractedLowest }
            self.priceFilter = prices.max() ?? Int.max
            
            self.ratingFilter = 1
            
            self.locationRatingFilter = 1
        } else {
            self.sortMethod = .recommended
            self.priceFilter = Int.max
            self.ratingFilter = 1
            self.locationRatingFilter = 1
        }
    }
    
    var hotelPrices: [Int] {
        guard let data = hotelsResponse.data else {
            return []
        }
        
        return data.properties.compactMap { $0.totalRate?.extractedLowest }
    }
    
    var filteredHotels: [Property] {
        guard let data = hotelsResponse.data else {
            print("No hotelsResponse data")
            return []
        }
        
        return data.properties
            .filter {
                $0.totalRate?.extractedLowest ?? 0 <= priceFilter
            }
            .filter {
                $0.overallRating ?? 5 >= Double(ratingFilter)
            }
            .filter {
                $0.locationRating ?? 5 >= Double(locationRatingFilter)
            }
            .sorted {
                switch sortMethod {
                case .recommended:
                    return true
                case .cheapest:
                    return $0.totalRate?.extractedLowest ?? 0 < $1.totalRate?.extractedLowest ?? 0
                case .mostExpensive:
                    return $0.totalRate?.extractedLowest ?? 0 > $1.totalRate?.extractedLowest ?? 0
                case .rating:
                    return $0.overallRating ?? 0 > $1.overallRating ?? 0
                }
            }
    }
    
    func getHotels() async {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.hotelsResponse = ApiResponse(status: .loading)
            self.resetFilters()
        }
        
        do {
            let fetchedHotels = try await fetchHotels(location: location,
                                                      fromDate: fromDate.EuropeanFormat(),
                                                      toDate: toDate.EuropeanFormat())
            
            
            if let retrievedHotels = fetchedHotels.data {
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.hotelsResponse = ApiResponse(status: .success, data: retrievedHotels)
                    self.tripViewModel.hotelsResponse = ApiResponse(status: .success, data: retrievedHotels)
                    self.tripViewModel.hotelsPrice = retrievedHotels.properties.last?.totalRate?.extractedLowest ?? 0
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

func determineIcon(for amenity: String) -> String {
    let amenityIcons: [String: String] = [
        "wi-fi": "wifi",
        "pool": "water.waves",
        "hot tub": "water.waves",
        "balcony": "sun.horizon.fill",
        "patio": "sun.horizon.fill",
        "air conditioning": "air.conditioner.vertical.fill",
        "shuttle": "bus.fill",
        "breakfast": "fork.knife",
        "kitchen": "fork.knife",
        "smoke-free": "nosign",
        "washer": "washer",
        "laundry": "washer",
        "dryer": "washer",
        "wheelchair": "wheelchair",
        "parking": "parkingsign.square.fill",
        "fitness": "dumbbell.fill",
        "crib": "bed.double.fill",
        "tv": "tv.fill",
        "bar": "wineglass.fill",
        "spa": "drop.fill",
        "beach": "beach.umbrella.fill",
        "restaurant": "takeoutbag.and.cup.and.straw.fill",
        "room service": "bell.fill",
        "accessible": "figure.roll",
        "business": "briefcase.fill",
        "kid": "figure.and.child.holdinghands",
        "child": "figure.and.child.holdinghands",
        "elevator": "arrow.up.arrow.down.circle.fill",
        "golf": "figure.golf",
        "pet": "pawprint.fill",
        "ironing": "tshirt.fill",
    ]
    
    for (key, icon) in amenityIcons {
        if amenity.lowercased().contains(key) {
            return icon
        }
    }
    
    return "minus"
}
