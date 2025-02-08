import Foundation

enum SortHotelsEnum: CaseIterable {
    case recommended
    case cheapest
    case mostExpensive
    case rating
    
    var title: String {
        switch self {
        case .recommended: return "Recommended"
        case .cheapest: return "Cheapest"
        case .mostExpensive: return "Most Expensive"
        case .rating: return "Rating"
        }
    }
}
