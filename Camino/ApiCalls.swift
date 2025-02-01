import Foundation

let baseUrl = "https://d9hepdo8p4.execute-api.us-east-1.amazonaws.com/dev"

func fetchData<T: Decodable>(endpoint: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601) async throws -> T {
    guard let url = URL(string: endpoint) else {
        throw CaminoError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
//    if endpoint.contains("lat") {
//        print(response)
//        if let rawData = String(data: data, encoding: .utf8) {
//            print("Raw Response: \(rawData)")
//        } else {
//            print("Unable to convert data to string")
//        }
//    }
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw CaminoError.invalidResponse
    }
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = dateDecodingStrategy
    
    do {
        return try decoder.decode(T.self, from: data)
    } catch let DecodingError.keyNotFound(key, _) {
        print("Missing key: \(key.stringValue)") // Print the missing key
        throw CaminoError.invalidData
    } catch {
        print("Decoding error: \(error)")
        throw CaminoError.invalidData
    }
}

func customDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter
}

////////////////////////////////////////////////////////
///NEW API CALLS
func fetchConcerts(category: String) async throws -> ApiResponse<ConcertsResponse> {
    let endpoint = "\(baseUrl)/concerts?category=\(category)"
    let response: ApiResponse<ConcertsResponse> = try await fetchData(endpoint: endpoint)
    return response
}

func fetchFeaturedConcert(category: String) async throws -> ApiResponse<FeaturedConcertResponse> {
    let endpoint = "\(baseUrl)/concerts?category=\(category)_featured"
    let response: ApiResponse<FeaturedConcertResponse> = try await fetchData(endpoint: endpoint)
    return response
}

func fetchPopularArtists(category: String) async throws -> ApiResponse<PopularArtistsResponse> {
    let endpoint = "\(baseUrl)/popularArtists?category=\(category)"
    let response: ApiResponse<PopularArtistsResponse> = try await fetchData(endpoint: endpoint)
    return response
}

func fetchArtistDetails(id: String) async throws -> ApiResponse<ArtistDetailsResponse> {
    let endpoint = "\(baseUrl)/artistDetails?id=\(id)"
    let response: ApiResponse<ArtistDetailsResponse> = try await fetchData(endpoint: endpoint)
    return response
}

func fetchPopularDestinations() async throws -> ApiResponse<DestinationsResponse> {
    let endpoint = "\(baseUrl)/popularDestinations"
    let response: ApiResponse<DestinationsResponse> = try await fetchData(endpoint: endpoint)
    return response
}

func fetchFamousVenues() async throws -> ApiResponse<VenuesResponse> {
    let endpoint = "\(baseUrl)/famousVenues"
    let response: ApiResponse<VenuesResponse> = try await fetchData(endpoint: endpoint)
    return response
}

func fetchConcertsForDestination(lat: Double, long: Double) async throws -> ApiResponse<ConcertsResponse> {
    let endpoint = "\(baseUrl)/concerts?lat=\(lat)&long=\(long)"
    let response: ApiResponse<ConcertsResponse> = try await fetchData(endpoint: endpoint)
    return response
}

func fetchConcertsForVenue(venueId: String) async throws -> ApiResponse<ConcertsResponse> {
    let endpoint = "\(baseUrl)/concerts?venueId=\(venueId)"
    let response: ApiResponse<ConcertsResponse> = try await fetchData(endpoint: endpoint)
    return response
}

func fetchAirportSearchResults(query: String) async throws -> ApiResponse<AirportSearchResponse> {
    let endpoint = "\(baseUrl)/airportSearch?query=\(query)"
    let response: ApiResponse<AirportSearchResponse> = try await fetchData(endpoint: endpoint)
    return response
}

func fetchCitySearchResults(query: String) async throws -> ApiResponse<CitySearchResponse> {
    let endpoint = "\(baseUrl)/citySearch?query=\(query)"
    let response: ApiResponse<CitySearchResponse> = try await fetchData(endpoint: endpoint)
    return response
}

func fetchArtistSearchResults(query: String) async throws -> ApiResponse<ArtistSearchResponse> {
    let endpoint = "\(baseUrl)/artistSearch?query=\(query)"
    let response: ApiResponse<ArtistSearchResponse> = try await fetchData(endpoint: endpoint)
    return response
}

func fetchDepartureFlights(fromAirport: String, lat: Double, long: Double, fromDate: String, toDate: String) async throws -> ApiResponse<FlightsResponse> {
    let endpoint = "\(baseUrl)/flights?lat=\(lat)&long=\(long)&fromAirport=\(fromAirport)&fromDate=\(fromDate)&toDate=\(toDate)"
    let response: ApiResponse<FlightsResponse> = try await fetchData(endpoint: endpoint, dateDecodingStrategy: .formatted(customDateFormatter()))
    return response
}

func fetchDepartureFlights(fromAirport: String, toAirport: String, fromDate: String, toDate: String) async throws -> ApiResponse<FlightsResponse> {
    let endpoint = "\(baseUrl)/flights?fromAirport=\(fromAirport)&toAirport=\(toAirport)&fromDate=\(fromDate)&toDate=\(toDate)"
    let response: ApiResponse<FlightsResponse> = try await fetchData(endpoint: endpoint, dateDecodingStrategy: .formatted(customDateFormatter()))
    return response
}

func fetchReturnFlights(fromAirport: String, toAirport: String, fromDate: String, toDate: String, departureToken: String) async throws -> ApiResponse<FlightsResponse> {
    let endpoint = "\(baseUrl)/flights?fromAirport=\(fromAirport)&toAirport=\(toAirport)&fromDate=\(fromDate)&toDate=\(toDate)&departureToken=\(departureToken)"
    let response: ApiResponse<FlightsResponse> = try await fetchData(endpoint: endpoint, dateDecodingStrategy: .formatted(customDateFormatter()))
    return response
}

func fetchHotels(location: String, fromDate: String, toDate: String) async throws -> ApiResponse<HotelsResponse> {
    let endpoint = "\(baseUrl)/hotels?location=\(location)&fromDate=\(fromDate)&toDate=\(toDate)"
    let response: ApiResponse<HotelsResponse> = try await fetchData(endpoint: endpoint, dateDecodingStrategy: .formatted(customDateFormatter()))
    return response
}
////////////////////////////////////////////////////////

// Destinations

func fetchVenueDetails(venueId: String) async throws -> VenueDetailsResponse {
    let endpoint = "\(baseUrl)/venueDetails?id=\(venueId)"
    let response: VenueDetailsResponse = try await fetchData(endpoint: endpoint)
    return response
}

enum CaminoError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case missingDepartureToken
}
