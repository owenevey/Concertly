import Foundation


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

func fetchDepartureFlights(lat: Double, long: Double, fromAirport: String, fromDate: String, toDate: String) async throws -> FlightsResponse {
    let endpoint = "https://d9hepdo8p4.execute-api.us-east-1.amazonaws.com/dev/flights?lat=\(lat)&long=\(long)&fromAirport=\(fromAirport)&fromDate=\(fromDate)&toDate=\(toDate)"
    
    guard let url = URL(string: endpoint) else {
        throw CaminoError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw CaminoError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let decoded = try decoder.decode(FlightsResponse.self, from: data)
        
        return decoded
    } catch {
        throw CaminoError.invalidData
    }
}

func fetchDepartureFlights(fromAirport: String, toAirport: String, fromDate: String, toDate: String) async throws -> FlightsResponse {
    let endpoint = "https://d9hepdo8p4.execute-api.us-east-1.amazonaws.com/dev/flights?lat=42&long=-122&fromAirport=\(fromAirport)&fromDate=\(fromDate)&toDate=\(toDate)"
    
    guard let url = URL(string: endpoint) else {
        throw CaminoError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw CaminoError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let decoded = try decoder.decode(FlightsResponse.self, from: data)
        
        return decoded
    } catch {
        throw CaminoError.invalidData
    }
}


enum CaminoError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
