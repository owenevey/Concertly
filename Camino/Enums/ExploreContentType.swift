import Foundation

enum ExploreContentType {
    case concert
    case artist
    case place
    case venue
    
    var title: String {
        switch self {
        case .concert:
            return "concerts"
        case .artist:
            return "artists"
        case .place:
            return "places"
        case .venue:
            return "venues"
        }
    }
}
