import Foundation

struct ConcertsResponse: Codable {
    let concerts: [Concert]
}

struct Concert: Codable, Identifiable, Hashable {
    let names: [String]
    let id: String
    let artistName: String
    let artistId: String
    let urls: [String]
    let imageUrl: String
    let date: Date
    let timezone: String
    let venueName: String
    let venueAddress: String
    let cityName: String
    let latitude: Double
    let longitude: Double
    let lineup: [SuggestedArtist]
    let closestAirport: String?
    let sortKey: Int?
    var flightsPrice: Int?
    var hotelsPrice: Int?
}
