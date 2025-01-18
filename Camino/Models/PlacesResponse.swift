import Foundation

struct PlacesResponse: Codable {
    let places: [Place]
}

struct Place: Codable, Identifiable {
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
