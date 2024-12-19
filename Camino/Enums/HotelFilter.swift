import Foundation
import SwiftUI

enum HotelFilter: Equatable {
    case price(Binding<Int>, [Int])
    case rating
    case amenities
    
    static func allCases(priceFilter: Binding<Int>, hotelPrices: [Int]) -> [HotelFilter] {
        return [
            .price(priceFilter, hotelPrices),
            .rating,
            .amenities
        ]
    }
    
    var title: String {
        switch self {
        case .price: return "Price"
        case .rating: return "Rating"
        case .amenities: return "Amenities"
        }
    }
    
    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .price(let priceFilter, let flightPrices):
            FilterPrice(priceFilter: priceFilter, flightPrices: flightPrices)
        case .rating:
            Text("Rating")
        case .amenities:
            Text("Amenities")
        }
    
    }
    
    static func == (lhs: HotelFilter, rhs: HotelFilter) -> Bool {
        switch (lhs, rhs) {
        case (.rating, .rating):
            return true
        case (.price, .price):
            return true
        case (.amenities, .amenities):
            return true
        default:
            return false
        }
    }
}
