import Foundation

struct PopularDestinationsResponse: Codable {
    let destinations: [SuggestedDestination]
}

struct SuggestedDestination: Codable, Identifiable {
    var id: String {
        return name
    }
    let name: String
    let description: String
    let imageUrl: String
    let countryName: String
    
    private enum CodingKeys: String, CodingKey {
        case name,
             description,
             imageUrl,
             countryName
    }
}
