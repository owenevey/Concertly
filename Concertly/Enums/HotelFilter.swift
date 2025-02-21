import Foundation
import SwiftUI

enum HotelFilter: Equatable {
    case sort(Binding<SortHotelsEnum>)
    case price(Binding<Int>, [Int])
    case rating(Binding<Int>)
    case locationRating(Binding<Int>)
    
    static func allCases(sortMethod: Binding<SortHotelsEnum>, priceFilter: Binding<Int>, hotelPrices: [Int], ratingFilter: Binding<Int>, locationRatingFilter: Binding<Int>) -> [HotelFilter] {
        return [
            .sort(sortMethod),
            .price(priceFilter, hotelPrices),
            .rating(ratingFilter),
            .locationRating(locationRatingFilter)
        ]
    }
    
    var title: String {
        switch self {
        case .sort: return "Sort"
        case .price: return "Price"
        case .rating: return "Rating"
        case .locationRating: return "Location"
        }
    }
    
    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .sort(let sortMethod):
            SortHotels(sortMethod: sortMethod)
        case .price(let priceFilter, let flightPrices):
            FilterPrice(priceFilter: priceFilter, flightPrices: flightPrices)
        case .rating(let ratingFilter):
            FilterRating(ratingFilter: ratingFilter)
        case .locationRating(let locationRatingFilter):
            LocationRatingFilter(locationRatingFilter: locationRatingFilter)
        }
    }
    
    static func == (lhs: HotelFilter, rhs: HotelFilter) -> Bool {
        switch (lhs, rhs) {
        case (.rating, .rating):
            return true
        case (.price, .price):
            return true
        default:
            return false
        }
    }
}
