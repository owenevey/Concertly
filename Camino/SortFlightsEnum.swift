import Foundation

enum SortFlightsEnum: CaseIterable {
    case recommended
    case cheapest
    case mostExpensive
    case quickest
    case earliest
    
    var title: String {
        switch self {
        case .recommended: return "Recommended"
        case .cheapest: return "Cheapest"
        case .mostExpensive: return "Most Expensive"
        case .quickest: return "Quickest"
        case .earliest: return "Earliest"
        }
    }
}
