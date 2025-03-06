import Foundation

struct DestinationsResponse: Codable {
    let destinations: [Destination]
}

struct Destination: Codable, Identifiable, Hashable {
    var id: String {
        return name
    }
    let name: String
    let shortDescription: String
    let longDescription: String
    let images: [String]
    let cityName: String
    let countryName: String
    let latitude: Double
    let longitude: Double
    let geoHash: String
    let closestAirport: String
}
