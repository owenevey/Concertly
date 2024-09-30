import Foundation

struct ConcertsResponse: Decodable {
    let concerts: [Concert]
}

struct Concert: Decodable {
    let name: String
    let id: String
    let url: String
    let imageUrl: String
    let dateTime: String
    let minPrice: Double
    let maxPrice: Double
    let seatmapImageUrl: String
    let venue: Venue
}


struct Venue: Decodable {
    let name: String
    let id: String
    let url: String
    let imageUrl: String
    let latitude: String
    let longitude: String
}

func fetchConcertsFromAPI() async throws -> [Concert] {
    print("Running fetchConcertsFromAPI")
    let url = URL(string: "https://d9hepdo8p4.execute-api.us-east-1.amazonaws.com/dev/suggestedConcerts")!
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    let decoded = try JSONDecoder().decode(ConcertsResponse.self, from: data)
    
    return decoded.concerts
}

