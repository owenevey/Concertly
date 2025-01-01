import Foundation

let baseUrl = "https://d9hepdo8p4.execute-api.us-east-1.amazonaws.com/dev"

func fetchData<T: Decodable>(endpoint: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601) async throws -> T {
    guard let url = URL(string: endpoint) else {
        throw CaminoError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw CaminoError.invalidResponse
    }
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = dateDecodingStrategy
    
    do {
        return try decoder.decode(T.self, from: data)
    } catch {
        throw CaminoError.invalidData
    }
}

func customDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter
}

// Concerts

func fetchSuggestedConcerts() async throws -> [Concert] {
    let endpoint = "\(baseUrl)/suggestedConcerts"
    let response: ConcertsResponse = try await fetchData(endpoint: endpoint)
    return response.concerts
}


// Flights

func fetchDepartureFlights(lat: Double, long: Double, fromAirport: String, fromDate: String, toDate: String) async throws -> FlightsResponse {
    let endpoint = "\(baseUrl)/flights?lat=\(lat)&long=\(long)&fromAirport=\(fromAirport)&fromDate=\(fromDate)&toDate=\(toDate)"
    let response: FlightsResponse = try await fetchData(endpoint: endpoint, dateDecodingStrategy: .formatted(customDateFormatter()))
    return response
}

func fetchDepartureFlights(fromAirport: String, toAirport: String, fromDate: String, toDate: String) async throws -> FlightsResponse {
    let endpoint = "\(baseUrl)/flights?fromAirport=\(fromAirport)&toAirport=\(toAirport)&fromDate=\(fromDate)&toDate=\(toDate)"
    let response: FlightsResponse = try await fetchData(endpoint: endpoint, dateDecodingStrategy: .formatted(customDateFormatter()))
    return response
}

func fetchReturnFlights(fromAirport: String, toAirport: String, fromDate: String, toDate: String, departureToken: String) async throws -> FlightsResponse {
    let endpoint = "\(baseUrl)/flights?fromAirport=\(fromAirport)&toAirport=\(toAirport)&fromDate=\(fromDate)&toDate=\(toDate)&departureToken=\(departureToken)"
    let response: FlightsResponse = try await fetchData(endpoint: endpoint, dateDecodingStrategy: .formatted(customDateFormatter()))
    return response
}

func fetchAirportSearchResults(query: String) async throws -> AirportSearchResponse {
    let endpoint = "\(baseUrl)/airportSearch?query=\(query)"
    let response: AirportSearchResponse = try await fetchData(endpoint: endpoint)
    return response
}

// Hotels

func fetchHotels(location: String, fromDate: String, toDate: String) async throws -> HotelsResponse {
    let endpoint = "\(baseUrl)/hotels?location=\(location)&fromDate=\(fromDate)&toDate=\(toDate)"
    let response: HotelsResponse = try await fetchData(endpoint: endpoint, dateDecodingStrategy: .formatted(customDateFormatter()))
    return response
}

func fetchCitySearchResults(query: String) async throws -> CitySearchResponse {
    let endpoint = "\(baseUrl)/citySearch?query=\(query)"
    let response: CitySearchResponse = try await fetchData(endpoint: endpoint)
    return response
}

enum CaminoError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case missingDepartureToken
}
