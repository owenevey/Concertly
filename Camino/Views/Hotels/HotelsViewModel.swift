import Foundation
import SwiftUI

@MainActor
final class HotelsViewModel: ObservableObject {
    
    @Published var location: String
    @Published var fromDate: Date
    @Published var toDate: Date
    
    @Published var hotelsResponse: ApiResponse<HotelsResponse>
    
    @Published var sortMethod = SortHotelsEnum.recommended
    @Published var priceFilter: Int = Int.max
    @Published var ratingFilter: Int = 1
    @Published var locationRatingFilter: Int = 1
    
    @Published var selectedHotel: Property?
    
    
    init(location: String, fromDate: Date, toDate: Date, hotelsResponse: ApiResponse<HotelsResponse>) {
        self.location = location
        self.fromDate = fromDate
        self.toDate = toDate
        self.hotelsResponse = hotelsResponse
        
        resetFilters()
    }
    
    func resetFilters() {
        if let properties = hotelsResponse.data?.properties {
            
            self.sortMethod = .recommended
            
            let prices = properties.map { $0.totalRate.extractedLowest }
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
        
        return data.properties.map { $0.totalRate.extractedLowest }
    }
    
    var filteredHotels: [Property] {
        guard let data = hotelsResponse.data else {
            print("No hotelsResponse data")
            return []
        }
        
        return data.properties
            .filter {
                $0.totalRate.extractedLowest <= priceFilter
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
                    return $0.totalRate.extractedLowest < $1.totalRate.extractedLowest
                case .mostExpensive:
                    return $0.totalRate.extractedLowest > $1.totalRate.extractedLowest
                }
            }
    }
    
    func getHotels() async {
        withAnimation(.easeInOut) {
            self.hotelsResponse = ApiResponse(status: .loading)
            self.resetFilters()
        }
        
        do {
            try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
            let fetchedHotels = try await fetchHotels(location: location, fromDate: fromDate.traditionalFormat(), toDate: toDate.traditionalFormat())
            
            withAnimation(.easeInOut) {
                self.hotelsResponse = ApiResponse(status: .success, data: fetchedHotels)
                self.resetFilters()
            }
        } catch {
            print("Error fetching hotels: \(error)")
            withAnimation(.easeInOut) {
                self.hotelsResponse = ApiResponse(status: .error, error: error.localizedDescription)
                self.resetFilters()
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
        "business": "briefcase.roll",
        "kid": "figure.and.child.holdinghands",
        "child": "figure.and.child.holdinghands",
        "elevator": "arrow.up.arrow.down.circle.fill",
        "golf": "figure.golf",
        "pet": "pawprint.fill",
        "ironing": "tshirt.fill"
    ]
    
    for (key, icon) in amenityIcons {
        if amenity.lowercased().contains(key) {
            return icon
        }
    }
    
    return "minus"
}
