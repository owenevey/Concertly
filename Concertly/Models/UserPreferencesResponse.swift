import Foundation

struct UserPreferencesResponse: Codable {
    let followingArtists: [FollowedArtist]
    let city: String
    let latitude: Double
    let longitude: Double
    let airport: String

    enum CodingKeys: String, CodingKey {
        case followingArtists
        case city
        case latitude
        case longitude
        case airport
    }
}
