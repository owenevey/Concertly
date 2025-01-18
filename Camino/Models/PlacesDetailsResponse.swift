import Foundation

struct DestinationDetailsResponse: Codable {
    let destinationDetails: DestinationDetails
}

struct DestinationDetails: Codable {
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
