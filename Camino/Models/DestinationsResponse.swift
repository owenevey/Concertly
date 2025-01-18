import Foundation

struct DestinationsResponse: Codable {
    let destinations: [Destination]
}

struct Destination: Codable, Identifiable {
    var id = UUID()
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
