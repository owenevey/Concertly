import Foundation

let baseUrl = "https://d9hepdo8p4.execute-api.us-east-1.amazonaws.com/dev"

func fetchData<T: Decodable>(endpoint: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601) async throws -> T {
    guard let url = URL(string: endpoint) else {
        throw CaminoError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    if endpoint.contains("_featured") {
        print(response)
        if let rawData = String(data: data, encoding: .utf8) {
            print("Raw Response: \(rawData)")
        } else {
            print("Unable to convert data to string")
        }
    }
    
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

////////////////////////////////////////////////////////


func fetchSuggestedConcerts(genre: String = "") async throws -> ConcertsResponse {
    let endpoint = genre.isEmpty ? "\(baseUrl)/suggestedConcerts" : "\(baseUrl)/suggestedConcerts?genre=\(genre)"
    let response: ConcertsResponse = try await fetchData(endpoint: endpoint)
    return response
}

func fetchTrendingConcerts(genre: String = "") async throws -> ConcertsResponse {
    let endpoint = genre.isEmpty ? "\(baseUrl)/trendingConcerts" : "\(baseUrl)/trendingConcerts?genre=\(genre)"
    let response: ConcertsResponse = try await fetchData(endpoint: endpoint)
    return response
}

func fetchNearbyConcerts() async throws -> ConcertsResponse {
    let endpoint = "\(baseUrl)/nearbyConcerts?lat=12&long=34"
    let response: ConcertsResponse = try await fetchData(endpoint: endpoint)
    return response
}

func fetchFeaturedEvent(genre: String = "") async throws -> FeaturedConcertResponse {
    let endpoint = genre.isEmpty ? "\(baseUrl)/featuredEvent" : "\(baseUrl)/featuredEvent?genre=\(genre)"
    let response: FeaturedConcertResponse = try await fetchData(endpoint: endpoint)
    return response
}

// Artists

func fetchArtistSearchResults(query: String) async throws -> ArtistSearchResponse {
    let endpoint = "\(baseUrl)/artistSearch?query=\(query)"
    let response: ArtistSearchResponse = try await fetchData(endpoint: endpoint)
    return response
}



func fetchPopularArtists(genre: String = "") async throws -> PopularArtistsResponse {
    let endpoint = genre.isEmpty ? "\(baseUrl)/popularArtists" : "\(baseUrl)/popularArtists?genre=\(genre)"
    let response: PopularArtistsResponse = try await fetchData(endpoint: endpoint)
    return response
}

// Games

func fetchUpcomingGames() async throws -> GamesResponse {
    let endpoint = "\(baseUrl)/upcomingGames"
    let response: GamesResponse = try await fetchData(endpoint: endpoint)
    return response
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

// Destinations

func fetchPopularDestinations() async throws -> DestinationsResponse {
    let endpoint = "\(baseUrl)/popularDestinations"
    let response: DestinationsResponse = try await fetchData(endpoint: endpoint)
    return response
}

func fetchDestinationDetails(destinationId: String) async throws -> DestinationDetailsResponse {
    let endpoint = "\(baseUrl)/destinationDetails?id=\(destinationId)"
    let response: DestinationDetailsResponse = try await fetchData(endpoint: endpoint)
    return response
}

func fetchFamousVenues() async throws -> VenuesResponse {
    let endpoint = "\(baseUrl)/famousVenues"
    let response: VenuesResponse = try await fetchData(endpoint: endpoint)
    return response
}

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
