import Foundation

struct VenuesResponse: Codable {
    let venues: [Venue]
}

struct Venue: Codable, Identifiable {
    let id: String
    let name: String
    let imageUrl: String
    let cityName: String
    let countryName: String
    let latitude: Double
    let longitude: Double
    let description: String
}
