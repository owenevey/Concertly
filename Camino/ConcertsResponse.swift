import Foundation

struct ConcertsResponse: Decodable {
    let concerts: [Concert]
}

struct Concert: Decodable, Identifiable {
    let name: String
    let id: String
    let url: String
    let imageUrl: String
    let dateTime: Date
    let minPrice: Double
    let maxPrice: Double
    let venue: Venue
}

struct Venue: Decodable {
    let name: String
    let country: String
    let latitude: String
    let longitude: String
}

func fetchConcertsFromAPI() async throws -> [Concert] {
    let url = URL(string: "https://d9hepdo8p4.execute-api.us-east-1.amazonaws.com/dev/suggestedConcerts")!
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    let decoded = try decoder.decode(ConcertsResponse.self, from: data)
    
    return decoded.concerts
}

