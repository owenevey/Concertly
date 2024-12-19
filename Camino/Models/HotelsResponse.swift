import Foundation

struct HotelsResponse: Codable {
    let brands: [Brand]
    let properties: [Property]
}

struct Brand: Codable {
    let id: Int
    let name: String
    let children: [ChildBrand]?
}

struct ChildBrand: Codable {
    let id: Int
    let name: String
}

struct Property: Codable, Identifiable, Equatable {
    let id = UUID()
    var type: String
    var name: String
    var description: String?
    var link: String?
    var gpsCoordinates: GPSCoordinates?
    var checkInTime: String?
    var checkOutTime: String?
    var ratePerNight: RateBreakdown?
    var totalRate: RateBreakdown
    var prices: [PriceOffering]?
    var deal: String?
    var dealDescription: String?
    var nearbyPlaces: [NearbyPlace]?
    var hotelClass: String?
    var extractedHotelClass: Int?
    var images: [PropertyImage]?
    var overallRating: Double?
    var reviews: Int?
    var ratings: [Rating]?
    var locationRating: Double?
    var reviewsBreakdown: [ReviewsBreakdown]?
    var amenities: [String]?
    var propertyToken: String
    var serpapiPropertyDetailsLink: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case name
        case description
        case link
        case gpsCoordinates = "gps_coordinates"
        case checkInTime = "check_in_time"
        case checkOutTime = "check_out_time"
        case ratePerNight = "rate_per_night"
        case totalRate = "total_rate"
        case prices
        case deal
        case dealDescription = "deal_description"
        case nearbyPlaces = "nearby_places"
        case hotelClass = "hotel_class"
        case extractedHotelClass = "extracted_hotel_class"
        case images
        case overallRating = "overall_rating"
        case reviews
        case ratings
        case locationRating = "location_rating"
        case reviewsBreakdown = "reviews_breakdown"
        case amenities
        case propertyToken = "property_token"
        case serpapiPropertyDetailsLink = "serpapi_property_details_link"
    }
    
    static func == (lhs: Property, rhs: Property) -> Bool {
        return lhs.id == rhs.id
    }
}

struct GPSCoordinates: Codable {
    var latitude: Double
    var longitude: Double
}

struct RateBreakdown: Codable {
    var lowest: String
    var extractedLowest: Int
    var beforeTaxesFees: String? //issue causer
    var extractedBeforeTaxesFees: Int? //issue causer
    
    enum CodingKeys: String, CodingKey {
        case lowest
        case extractedLowest = "extracted_lowest"
        case beforeTaxesFees = "before_taxes_fees"
        case extractedBeforeTaxesFees = "extracted_before_taxes_fees"
    }
}

struct PriceOffering: Codable {
    var source: String
    var logo: String
    var numGuests: Int
    var ratePerNight: RateBreakdown
    
    enum CodingKeys: String, CodingKey {
        case source
        case logo
        case numGuests = "num_guests"
        case ratePerNight = "rate_per_night"
    }
}

struct NearbyPlace: Codable {
    var name: String?
    var transportations: [Transportation]?
}

struct Transportation: Codable {
    var name: String?
    var duration: String?
}

struct PropertyImage: Codable {
    var thumbnail: String?
    var originalImage: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbnail
        case originalImage = "original_image"
    }
}

struct Rating: Codable {
    var stars: Int?
    var count: Int?
}

struct ReviewsBreakdown: Codable {
    var name: String?
    var description: String?
    var totalMentioned: Int?
    var positive: Int?
    var negative: Int?
    var neutral: Int?
}
