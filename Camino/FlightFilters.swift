import Foundation
import SwiftUI

enum FlightFilter: CaseIterable {
    case sort
    case stops
    case time
    case airlines
    case duration
    case price
    case cabin
    
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
        case .airlines: Text("Airlines")
        case .duration: Text("Duration")
        case .price: Text("Price")
        case .cabin: Text("Cabin")
        }
    }
}
