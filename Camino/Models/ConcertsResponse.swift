import Foundation

struct ConcertsResponse: Codable {
    let concerts: [Concert]
}

struct Concert: Codable, Identifiable {
    let name: String
    let id: String
    let url: String
    let imageUrl: String
    let dateTime: Date
    let minPrice: Double
    let maxPrice: Double
    let venueName: String
    let venueAddress: String
    let generalLocation: String
    let latitude: Double
    let longitude: Double
}
