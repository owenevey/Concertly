import Foundation

struct DestinationsResponse: Codable {
    let destinations: [Destination]
}

struct Destination: Codable, Identifiable {
    var id: String {
        return name
    }
    let name: String
    let shortDescription: String
    let longDescription: String
    let images: [String]
    let cityName: String
    let countryName: String
    let latitude: Double
    let longitude: Double
    let geoHash: String
    
//    private enum CodingKeys: String, CodingKey {
//        case name,
//             shortDescription,
//             longDescription,
//             images,
//             cityName,
//             countryName,
//             geoHash,
//             latitude,
//             longitude
//    }
}
