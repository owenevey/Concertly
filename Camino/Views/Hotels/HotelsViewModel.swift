import Foundation
import SwiftUI

@MainActor
final class HotelsViewModel: ObservableObject {
    
    @Published var location: String
    @Published var fromDate: Date
    @Published var toDate: Date
    
    @Published var hotelsResponse: ApiResponse<HotelsResponse>
    @Published var selectedHotel: Property?
    
    @Published var priceFilter: Int = Int.max
    
    init(location: String, fromDate: Date, toDate: Date, hotelsResponse: ApiResponse<HotelsResponse>) {
        self.location = location
        self.fromDate = fromDate
        self.toDate = toDate
        self.hotelsResponse = hotelsResponse
        
        resetFilters()
    }
    
    func resetFilters() {
        if let properties = hotelsResponse.data?.properties {
            
            let prices = properties.map { $0.totalRate.extractedLowest }
            self.priceFilter = prices.max() ?? Int.max
            
        } else {
            self.priceFilter = Int.max
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
