import Foundation
import SwiftUI

enum FlightFilter: Equatable {
    case sort(Binding<SortFlightsEnum>)
    case airlines(Binding<[String: (imageURL: String, isEnabled: Bool)]>)
    case stops(Binding<FilterStopsEnum>)
    case price(Binding<Int>, [Int])
    case duration(Binding<Int>, [Int])
    case time(Binding<Int>, [Int])
    
    static func allCases(sortMethod: Binding<SortFlightsEnum>, airlines: Binding<[String: (imageURL: String, isEnabled: Bool)]>, stopsFilter: Binding<FilterStopsEnum>, priceFilter: Binding<Int>, flightPrices: [Int], durationFilter: Binding<Int>, flightDurations: [Int], timeFilter: Binding<Int>, flightTimes: [Int]) -> [FlightFilter] {
        return [
            .sort(sortMethod),
            .airlines(airlines),
            .stops(stopsFilter),
            .price(priceFilter, flightPrices),
            .duration(durationFilter, flightDurations),
            .time(timeFilter, flightTimes)
        ]
    }
    
    var title: String {
        switch self {
        case .sort: return "Sort"
        case .airlines: return "Airlines"
        case .stops: return "Stops"
        case .price: return "Price"
        case .duration: return "Duration"
        case .time: return "Time"
        }
    }
    
    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .sort(let sortMethod):
            SortFlights(sortMethod: sortMethod)
        case .airlines(let airlines):
            FilterAirlines(airlines: airlines)
        case .stops(let stopsFilter):
            FilterStops(stopsFilter: stopsFilter)
        case .price(let priceFilter, let flightPrices):
            FilterPrice(priceFilter: priceFilter, flightPrices: flightPrices)
        case .duration(let durationFilter, let flightDurations):
            FilterDuration(durationFilter: durationFilter, flightDurations: flightDurations)
        case .time(let timeFilter, let flightTimes):
            FilterTime(timeFilter: timeFilter, flightTimes: flightTimes)
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
            return lhsAirlines.wrappedValue.elementsEqual(rhsAirlines.wrappedValue) { (lhsElem, rhsElem) -> Bool in
                return lhsElem.key == rhsElem.key && lhsElem.value == rhsElem.value
            }
        default:
            return false
        }
    }
}
