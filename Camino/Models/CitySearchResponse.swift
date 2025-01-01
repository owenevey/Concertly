import Foundation

struct CitySearchResponse: Codable {
    let suggestedCities: [SuggestedCity]
}

struct SuggestedCity: Codable {
    let name: String
    let stateCode: String?
    let countryName: String
    let countryCode: String
}
