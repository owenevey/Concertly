import Foundation

struct PlacesResponse: Codable {
    let places: [Place]
}

struct Place: Codable, Identifiable {
    var id = UUID()
    let name: String
    let shortDescription: String
    let longDescription: String
    let images: [String]
    let cityName: String
    let countryName: String
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
            case name, shortDescription, longDescription, images, cityName, countryName, latitude, longitude
        }
}
