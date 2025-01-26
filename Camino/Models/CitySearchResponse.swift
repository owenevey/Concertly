import Foundation

struct CitySearchResponse: Codable {
    let suggestedCities: [SuggestedCity]
}

struct SuggestedCity: Codable, Identifiable {
    var id: String {
        return "\(name), \(countryName)"
    }
    let name: String
    let stateCode: String?
    let countryName: String
    let countryCode: String
}
