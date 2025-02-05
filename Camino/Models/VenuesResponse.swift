import Foundation

struct VenuesResponse: Codable {
    let venues: [Venue]
}

struct Venue: Codable, Identifiable {
    let id: String
    let name: String
    let imageUrl: String
    let description: String
    let cityName: String
    let countryName: String
    let latitude: Double
    let longitude: Double
    let address: String
    let closestAirport: String
}
