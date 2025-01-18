import Foundation

struct PlaceDetailsResponse: Codable {
    let placeDetails: PlaceDetails
}

struct PlaceDetails: Codable {
    let name: String
    let description: String
    let images: [String]
    let cityName: String
    let countryName: String
    let latitude: Double
    let longitude: Double
    let concerts: [Concert]
    
    private enum CodingKeys: String, CodingKey {
        case name,
             description,
             images,
             cityName,
             countryName,
             latitude,
             longitude,
             concerts
    }
}
