import Foundation

struct UserPreferencesRequest: Codable {
    let city: String?
    let latitude: Double?
    let longitude: Double?
    let airport: String?
}

