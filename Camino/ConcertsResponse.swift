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
    let venueName: String
    let venueAddress: String
    let generalLocation: String
    let latitude: Double
    let longitude: Double
}

func fetchConcertsFromAPI() async throws -> [Concert] {
    let url = URL(string: "https://d9hepdo8p4.execute-api.us-east-1.amazonaws.com/dev/suggestedConcerts")!
    
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check if response is valid (e.g., status code 200)
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            print("Server returned an error with status code: \(httpResponse.statusCode)")
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decoded = try decoder.decode(ConcertsResponse.self, from: data)
        
        return decoded.concerts
    } catch let urlError as URLError {
        // Handle URL or network related errors
        print("URL Error: \(urlError.localizedDescription)")
        throw urlError
    } catch let decodingError as DecodingError {
        // Handle JSON decoding errors
        print("Decoding Error: \(decodingError.localizedDescription)")
        print("Decoding Error details: \(decodingError)")
        throw decodingError
    } catch {
        // Handle any other types of errors
        print("Unknown error: \(error.localizedDescription)")
        throw error
    }
}


