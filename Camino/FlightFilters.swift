import Foundation
import SwiftUI

enum FlightFilter: Equatable {
    case sort
    case stops
    case time
    case airlines(AirlinesFilterParams)
    case duration
    case price
    case cabin
    
    static func allCases(airlines: Binding<[String: (imageURL: String, isEnabled: Bool)]>) -> [FlightFilter] {
        return [
            .sort,
            .stops,
            .time,
            .airlines(AirlinesFilterParams(airlines: airlines)),
            .duration,
            .price,
            .cabin
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
        case .cabin: return "Cabin"
        }
    }
    
    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .sort: Text("Sort")
        case .stops: Text("Stops")
        case .time: Text("Time")
        case .airlines(let params):
            FilterAirlines(airlines: params.airlines)
        case .duration: Text("Duration")
        case .price: Text("Price")
        case .cabin: Text("Cabin")
        }
    }
    
    static func == (lhs: FlightFilter, rhs: FlightFilter) -> Bool {
        switch (lhs, rhs) {
        case (.sort, .sort),
            (.stops, .stops),
            (.time, .time),
            (.duration, .duration),
            (.price, .price),
            (.cabin, .cabin):
            return true
        case (.airlines(let lhsParams), .airlines(let rhsParams)):
            // Compare the dictionaries themselves instead of `wrappedValue`
            return lhsParams.airlines.wrappedValue.elementsEqual(rhsParams.airlines.wrappedValue) { (lhsElem, rhsElem) -> Bool in
                return lhsElem.key == rhsElem.key && lhsElem.value == rhsElem.value
            }
        default:
            return false
        }
    }
}


struct AirlinesFilterParams {
    var airlines: Binding<[String: (imageURL: String, isEnabled: Bool)]>
}
