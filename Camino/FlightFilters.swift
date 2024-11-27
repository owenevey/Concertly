import Foundation
import SwiftUI

enum FlightFilter: Equatable {
    case sort(Binding<SortFlightsEnum>)
    case stops(Binding<FilterStopsEnum>)
    case time
    case airlines(Binding<[String: (imageURL: String, isEnabled: Bool)]>)
    case duration(Binding<Int>, [Int])
    case price(Binding<Int>, [Int])
    
    static func allCases(airlines: Binding<[String: (imageURL: String, isEnabled: Bool)]>, sortMethod: Binding<SortFlightsEnum>, stopsFilter: Binding<FilterStopsEnum>, durationFilter: Binding<Int>, flightDurations: [Int], priceFilter: Binding<Int>, flightPrices: [Int]) -> [FlightFilter] {
        return [
            .sort(sortMethod),
            .stops(stopsFilter),
            .time,
            .airlines(airlines),
            .duration(durationFilter, flightDurations),
            .price(priceFilter, flightPrices),
        ]
    }
    
    var title: String {
        switch self {
        case .sort: return "Sort"
        case .stops: return "Stops"
        case .time: return "Time"
        case .airlines: return "Airlines"
        case .duration: return "Duration"
        case .price: return "Price"
        }
    }
    
    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .sort(let sortMethod):
            SortFlights(sortMethod: sortMethod)
        case .stops(let stopsFilter):
            FilterStops(stopsFilter: stopsFilter)
        case .time: Text("Time")
        case .airlines(let airlines):
            FilterAirlines(airlines: airlines)
        case .duration(let durationFilter, let flightDurations):
            FilterDuration(durationFilter: durationFilter, flightDurations: flightDurations)
        case .price(let priceFilter, let flightPrices):
            FilterPrice(priceFilter: priceFilter, flightPrices: flightPrices)
        }
    }
    
    static func == (lhs: FlightFilter, rhs: FlightFilter) -> Bool {
        switch (lhs, rhs) {
        case (.sort, .sort),
            (.stops, .stops),
            (.time, .time),
            (.duration, .duration),
            (.price, .price):
            return true
        case (.airlines(let lhsAirlines), .airlines(let rhsAirlines)):
            // Compare the dictionaries directly instead of `wrappedValue`
            return lhsAirlines.wrappedValue.elementsEqual(rhsAirlines.wrappedValue) { (lhsElem, rhsElem) -> Bool in
                return lhsElem.key == rhsElem.key && lhsElem.value == rhsElem.value
            }
        default:
            return false
        }
    }
}
