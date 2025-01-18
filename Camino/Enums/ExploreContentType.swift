import Foundation

enum ExploreContentType {
    case concert
    case artist
    case destination
    case venue
    
    var title: String {
        switch self {
        case .concert:
            return "concerts"
        case .artist:
            return "artists"
        case .destination:
            return "destinations"
        case .venue:
            return "venues"
        }
    }
}
