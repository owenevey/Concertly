import Foundation

struct UserPreferencesRequest: Codable {
    let artists: [FollowedArtist]?
    let follow: Bool?
    let city: String?
    let latitude: Double?
    let longitude: Double?
    let airport: String?

    enum CodingKeys: String, CodingKey {
        case artists
        case follow
        case city
        case latitude
        case longitude
        case airport
    }
}

struct FollowedArtist: Codable {
    let id: String
    let name: String
}
