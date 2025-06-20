import Foundation

let baseUrl = "https://d9hepdo8p4.execute-api.us-east-1.amazonaws.com/dev"

func fetchData<T: Decodable, U: Encodable>(endpoint: String, method: String = "GET", body: U? = nil, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601) async throws -> T {
    func makeRequest(with token: String) throws -> URLRequest {
        guard let url = URL(string: endpoint) else {
            throw ConcertlyError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    func makeCall(with request: URLRequest, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ConcertlyError.invalidResponse
        }

        if httpResponse.statusCode == 401 {
            throw ConcertlyError.unauthorized
        }
        
        guard httpResponse.statusCode == 200 else {
            throw ConcertlyError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return try decoder.decode(T.self, from: data)
    }
    
    guard let token = KeychainUtil.get(forKey: "idToken") else {
        throw ConcertlyError.missingIdToken
    }
    
    do {
        let request = try makeRequest(with: token)
        return try await makeCall(with: request, dateDecodingStrategy: dateDecodingStrategy)
    } catch ConcertlyError.unauthorized {
        try await AuthenticationManager.shared.refreshTokens()
        
        guard let newToken = KeychainUtil.get(forKey: "idToken") else {
            throw ConcertlyError.missingIdToken
        }
                
        let retryRequest = try makeRequest(with: newToken)
        return try await makeCall(with: retryRequest, dateDecodingStrategy: dateDecodingStrategy)
    }
}

func fetchData<T: Decodable>(
    endpoint: String,
    method: String = "GET",
    dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
) async throws -> T {
    try await fetchData(endpoint: endpoint, method: method, body: Optional<Never>.none, dateDecodingStrategy: dateDecodingStrategy)
}


func customDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter
}

////////////////////////////////////////////////////////
func fetchMinimumVersion() async throws -> String? {
    let endpoint = "\(baseUrl)/minimumVersion"
    let response: ApiResponse<String> = try await fetchData(endpoint: endpoint)
    return response.data
}

func fetchOutage() async throws -> Bool? {
    let endpoint = "\(baseUrl)/outage"
    let response: ApiResponse<Bool> = try await fetchData(endpoint: endpoint)
    return response.data
}

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

func fetchArtistImage(id: String) async throws -> ApiResponse<String> {
    let endpoint = "\(baseUrl)/artistImage?id=\(id)"
    let response: ApiResponse<String> = try await fetchData(endpoint: endpoint)
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

func fetchFlightsBookingUrl(fromAirport: String, toAirport: String, fromDate: String, toDate: String, bookingToken: String) async throws -> ApiResponse<String> {
    let endpoint = "\(baseUrl)/flights?fromAirport=\(fromAirport)&toAirport=\(toAirport)&fromDate=\(fromDate)&toDate=\(toDate)&bookingToken=\(bookingToken)"
    let response: ApiResponse<String> = try await fetchData(endpoint: endpoint, dateDecodingStrategy: .formatted(customDateFormatter()))
    return response
}

func fetchHotels(location: String, fromDate: String, toDate: String) async throws -> ApiResponse<HotelsResponse> {
    let endpoint = "\(baseUrl)/hotels?location=\(location)&fromDate=\(fromDate)&toDate=\(toDate)"
    let response: ApiResponse<HotelsResponse> = try await fetchData(endpoint: endpoint, dateDecodingStrategy: .formatted(customDateFormatter()))
    return response
}

func fetchHotelsBookingUrl(location: String, fromDate: String, toDate: String, propertyToken: String) async throws -> ApiResponse<String> {
    let endpoint = "\(baseUrl)/hotels?location=\(location)&fromDate=\(fromDate)&toDate=\(toDate)&propertyToken=\(propertyToken)"
    let response: ApiResponse<String> = try await fetchData(endpoint: endpoint, dateDecodingStrategy: .formatted(customDateFormatter()))
    return response
}

func fetchSimilarConcerts(followingArtists: [SuggestedArtist]) async throws -> ApiResponse<SuggestedConcertsResponse> {
    let endpoint = "\(baseUrl)/similarConcerts"
    
    let artistsRequest = SuggestedArtistsRequest(artists: followingArtists)
    
    let response: ApiResponse<SuggestedConcertsResponse> = try await fetchData(endpoint: endpoint, method: "POST", body: artistsRequest)
    return response
}

func toggleFollowArtist(artistId: String, follow: Bool) async throws -> ApiResponse<String> {
    let endpoint = "\(baseUrl)/followArtist"
    
    let followRequest = FollowRequest(artistId: artistId, follow: follow)
    
    let response: ApiResponse<String> = try await fetchData(endpoint: endpoint, method: "POST", body: followRequest)
    return response
}

func updateUserPreferences(request: UserPreferencesRequest) async throws -> ApiResponse<String> {
    let endpoint = "\(baseUrl)/updatePreferences"
    
    let response: ApiResponse<String> = try await fetchData(endpoint: endpoint, method: "POST", body: request)
    return response
}

func fetchUserPreferences() async throws -> ApiResponse<UserPreferencesResponse> {
    let endpoint = "\(baseUrl)/user"
    
    let response: ApiResponse<UserPreferencesResponse> = try await fetchData(endpoint: endpoint, method: "GET")
    return response
}

func fetchFollowedArtists() async throws -> ApiResponse<[SuggestedArtist]> {
    let endpoint = "\(baseUrl)/followedArtists"
    
    let response: ApiResponse<[SuggestedArtist]> = try await fetchData(endpoint: endpoint, method: "GET")
    return response
}

func updateDeviceToken(deviceId: String, pushNotificationToken: String? = nil, isNotificationsEnabled: Bool? = nil) async throws -> ApiResponse<String> {
    let endpoint = "\(baseUrl)/updateToken"
    
    let request = UpdateTokenRequest(deviceId: deviceId, pushNotificationToken: pushNotificationToken, isNotificationsEnabled: isNotificationsEnabled)
    
    let response: ApiResponse<String> = try await fetchData(endpoint: endpoint, method: "POST", body: request)
    return response
}

func deleteUser() async throws -> ApiResponse<String> {
    let endpoint = "\(baseUrl)/deleteUser"
    
    let response: ApiResponse<String> = try await fetchData(endpoint: endpoint, method: "GET")
    return response
}


enum ConcertlyError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unauthorized
    case missingIdToken
    case missingDepartureToken
    case missingBookingToken
}
