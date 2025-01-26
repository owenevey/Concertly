import Foundation

struct FlightsResponse: Codable {
    let flights: [FlightItem]
    let priceInsights: PriceInsights?
    let airports: [AirportInfo]
    
    init(flights: [FlightItem] = [],
         priceInsights: PriceInsights = PriceInsights(),
         airports: [AirportInfo] = []) {
        self.flights = flights
        self.priceInsights = priceInsights
        self.airports = airports
    }
}

struct FlightItem: Codable, Identifiable, Equatable {
    let id = UUID()
    let flights: [Flight]
    let layovers: [Layover]?
    let totalDuration: Int
    let carbonEmissions: CarbonEmissions
    let price: Int
    let type: String
    let airlineLogo: String
    let extensions: [String]?
    let departureToken: String?
    let bookingToken: String?
    
    enum CodingKeys: String, CodingKey {
        case flights
        case layovers
        case totalDuration = "total_duration"
        case carbonEmissions = "carbon_emissions"
        case price
        case type
        case airlineLogo = "airline_logo"
        case extensions
        case departureToken = "departure_token"
        case bookingToken = "booking_token"
    }
    
    static func == (lhs: FlightItem, rhs: FlightItem) -> Bool {
        return lhs.flights == rhs.flights &&
        lhs.totalDuration == rhs.totalDuration &&
        lhs.price == rhs.price &&
        lhs.type == rhs.type
    }
}

struct Flight: Codable, Identifiable, Equatable {
    let id = UUID()
    let departureAirport: Airport
    let arrivalAirport: Airport
    let duration: Int
    let airplane: String?
    let airline: String
    let airlineLogo: String
    let travelClass: String
    let flightNumber: String
    let legroom: String
    let extensions: [String]
    let oftenDelayedByOver30Min: Bool?
    
    enum CodingKeys: String, CodingKey {
        case departureAirport = "departure_airport"
        case arrivalAirport = "arrival_airport"
        case duration
        case airplane
        case airline
        case airlineLogo = "airline_logo"
        case travelClass = "travel_class"
        case flightNumber = "flight_number"
        case legroom
        case extensions
        case oftenDelayedByOver30Min = "often_delayed_by_over_30_min"
    }
    
    static func == (lhs: Flight, rhs: Flight) -> Bool {
            return lhs.departureAirport == rhs.departureAirport &&
                   lhs.arrivalAirport == rhs.arrivalAirport &&
                   lhs.duration == rhs.duration &&
                   lhs.flightNumber == rhs.flightNumber &&
                   lhs.airline == rhs.airline &&
                   lhs.travelClass == rhs.travelClass
        }
}

struct Airport: Codable, Equatable {
    let id: String
    let name: String
    let time: Date
    
    static func == (lhs: Airport, rhs: Airport) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.time == rhs.time
    }
}

struct Layover: Codable {
    let duration: Int
    let name: String
    let id: String
    let overnight: Bool?
}

struct CarbonEmissions: Codable {
    let thisFlight: Int
    let typicalForThisRoute: Int
    let differencePercent: Int
    
    enum CodingKeys: String, CodingKey {
        case thisFlight = "this_flight"
        case typicalForThisRoute = "typical_for_this_route"
        case differencePercent = "difference_percent"
    }
}

struct PriceInsights: Codable {
    let lowestPrice: Int
    let priceLevel: String
    let typicalPriceRange: [Int]
    let priceHistory: [[Int]]
    
    enum CodingKeys: String, CodingKey {
        case lowestPrice = "lowest_price"
        case priceLevel = "price_level"
        case typicalPriceRange = "typical_price_range"
        case priceHistory = "price_history"
    }
    
    init(lowestPrice: Int = 0,
         priceLevel: String = "",
         typicalPriceRange: [Int] = [],
         priceHistory: [[Int]] = []) {
        self.lowestPrice = lowestPrice
        self.priceLevel = priceLevel
        self.typicalPriceRange = typicalPriceRange
        self.priceHistory = priceHistory
    }
}

struct AirportInfo: Codable {
    let departure: [AirportDetail]
    let arrival: [AirportDetail]
    
    enum CodingKeys: String, CodingKey {
        case departure
        case arrival
    }
}

struct AirportDetail: Codable {
    let airport: AirportSummary
    let city: String
    let country: String
    let countryCode: String
    let image: String
    let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case airport
        case city
        case country
        case countryCode = "country_code"
        case image
        case thumbnail
    }
}

struct AirportSummary: Codable {
    let id: String
    let name: String
}
