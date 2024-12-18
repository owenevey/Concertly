import Foundation

enum FilterStopsEnum: CaseIterable {
    case any
    case nonstop
    case oneOrLess
    case twoOrLess
    
    var title: String {
        switch self {
        case .any: return "Any"
        case .nonstop: return "Nonstop"
        case .oneOrLess: return "One or less"
        case .twoOrLess: return "Two or less"
        }
    }
}
