import Foundation

struct CitySearchResponse: Codable {
    let suggestedCities: [SuggestedCity]
}

struct SuggestedCity: Codable, Identifiable {
    var id: String {
        return "\(name), \(stateCode ?? ""), \(countryName)"
    }
    var name: String
    let stateCode: String?
    let countryName: String
    let countryCode: String
    let latitude: Double
    let longitude: Double
}
