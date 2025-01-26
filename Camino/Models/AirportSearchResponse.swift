import Foundation

struct AirportSearchResponse: Codable {
    let suggestedAirports: [SuggestedAirport]
}

struct SuggestedAirport: Codable {
    var id: String {
        return "\(name), \(code)"
    }
    let name: String
    let code: String
    let city: String
    let country: String
}
