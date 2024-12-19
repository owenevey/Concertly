import SwiftUI

struct HotelCard: View {
    
    let property: Property
    
    var body: some View {
        HStack(spacing: 10) {
            if let url = property.images?.first?.originalImage {
                AsyncImage(url: URL(string: url)) { image in
                    image
                        .resizable()
                } placeholder: {
                    Color.foreground
                }
                .scaledToFill()
                .frame(width: 140, height: 170)
                .clipped()
                .padding(.leading, -15)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(property.name)
                        .font(.system(size: 20, type: .Medium))
                    
                    if let rating = property.overallRating {
                        HStack(spacing: 5) {
                            Text("\(rating, specifier: "%.1f")")
                                .font(.system(size: 18, type: .Medium))
                            Image(systemName: "star.fill")
                                .font(.system(size: 15))
                                .foregroundStyle(Color.yellow)
                        }
                    }
                }
                
                if let amenities = property.amenities {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(amenities.prefix(2), id: \.self) { amenity in
                            HStack(spacing: 5) {
                                switch amenity.lowercased() {
                                case "wi-fi":
                                    Image(systemName: "wifi")
                                case "air conditioning":
                                    Image(systemName: "air.conditioner.vertical.fill")
                                case "pool":
                                    Image(systemName: "water.waves")
                                case "outdoor pool":
                                    Image(systemName: "water.waves")
                                case "balcony":
                                    Image(systemName: "sun.max.fill")
                                case "airport shuttle":
                                    Image(systemName: "bus.fill")
                                default:
                                    Image(systemName: "circle.fill")
                                }
                            
                                Text(amenity)
                                    .font(.system(size: 16, type: .Regular))
                            }
                            .foregroundStyle(.gray3)
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text(property.totalRate.extractedLowest, format: .currency(code: "USD").precision(.fractionLength(0)))
                        .font(.system(size: 25, type: .Medium))
                        .frame(width: 100, alignment: .trailing)
                }
            }
            
            .frame(maxWidth: .infinity)
            
        }
        .padding(15)
        .frame(height: 170)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.foreground)
                .stroke(.gray2, style: StrokeStyle(lineWidth: 1))
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    HotelCard(property: Property(
        type: "vacation rental",
        name: "Le Sabot Ubud",
        description: "A beautiful vacation rental in Ubud, perfect for relaxation.",
        gpsCoordinates: GPSCoordinates(latitude: -8.509260177612305, longitude: 115.25045776367188),
        checkInTime: "3:00 PM",
        checkOutTime: "12:00 PM",
        ratePerNight: RateBreakdown(lowest: "$74", extractedLowest: 74, beforeTaxesFees: "$61", extractedBeforeTaxesFees: 61),
        totalRate: RateBreakdown(lowest: "$74", extractedLowest: 74, beforeTaxesFees: "$61", extractedBeforeTaxesFees: 61),
        prices: [PriceOffering(source: "Bluepillow.com", logo: "https://www.gstatic.com/travel-hotels/branding/190ff319-d0fd-4c45-bfc8-bad6f5f395f2.png", numGuests: 3, ratePerNight: RateBreakdown(lowest: "$74", extractedLowest: 74, beforeTaxesFees: "$61", extractedBeforeTaxesFees: 61))],
        nearbyPlaces: [NearbyPlace(name: "I Gusti Ngurah Rai International Airport", transportations: [Transportation(name: "Taxi", duration: "1 hr 8 min"), Transportation(name: "Public transport", duration: "2 hr 44 min")])],
        images: [PropertyImage(thumbnail: "https://lh5.googleusercontent.com/proxy/RTKoKMHU_6OXNOjYE9UaEHChawVvh4jp-KY9zBcLD94qHxRpUNrrVldDIHO7pufO32G1UwmzFD154iJOqTqAQGTdonIj10MJt3rynytZTSnUV31xpttlFWATWSOOq8S3sqF9UsOcJ32pQ=s287-w287-h192-n-k-no-v1", originalImage: "https://metasearch-cdn.azureedge.net/remote/i.travelapi.com/lodging/37000000/36160000/36156700/36156677/1a9d3cec_z.jpg?w=1024&h=750&mode=crop&scale=both&anchor=middlecenter")],
        overallRating: 4.5,
        reviews: 10,
        ratings: [Rating(stars: 5, count: 8), Rating(stars: 4, count: 2)],
        locationRating: 4.8,
        reviewsBreakdown: [ReviewsBreakdown(name: "Cleanliness", description: "How clean was the property?", totalMentioned: 9, positive: 8, negative: 1, neutral: 0)],
        amenities: ["Wi-Fi", "Air Conditioning", "Pool"],
        propertyToken: "12345",
        serpapiPropertyDetailsLink: "https://www.serpapi.com/property/12345"
    ))
    .padding(15)
}
