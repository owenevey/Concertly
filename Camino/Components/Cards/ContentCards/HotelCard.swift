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
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(property.name)
                        .font(.system(size: 18, type: .Medium))
                    if let rating = property.overallRating {
                        HStack(spacing: 5) {
                            Text("\(rating, specifier: "%.1f")")
                                .font(.system(size: 16, type: .Medium))
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.yellow)
                        }
                    }
                }
                .padding(.bottom, 5)
                
                if let amenities = property.amenities {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(amenities.prefix(3), id: \.self) { amenity in
                            HStack(spacing: 5) {
                                Image(systemName: determineIcon(for: amenity))
                                    .font(.system(size: 14))
                                    .frame(width: 20)
                                
                                Text(amenity)
                                    .font(.system(size: 14, type: .Regular))
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
                        .frame(alignment: .trailing)
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
    
    func determineIcon(for amenity: String) -> String {
        let amenityIcons: [String: String] = [
            "wi-fi": "wifi",
            "pool": "water.waves",
            "hot tub": "water.waves",
            "balcony": "sun.horizon.fill",
            "patio": "sun.horizon.fill",
            "air conditioning": "air.conditioner.vertical.fill",
            "shuttle": "bus.fill",
            "breakfast": "fork.knife",
            "kitchen": "fork.knife",
            "smoke-free": "nosign",
            "washer": "washer",
            "laundry": "washer",
            "dryer": "washer",
            "wheelchair": "wheelchair",
            "parking": "parkingsign.square.fill",
            "fitness": "dumbbell.fill",
            "crib": "bed.double.fill",
            "tv": "tv.fill",
            "bar": "wineglass.fill",
            "spa": "drop.fill",
            "beach": "beach.umbrella.fill",
            "restaurant": "takeoutbag.and.cup.and.straw.fill",
            "room service": "bell.fill",
            "accessible": "figure.roll",
            "business": "briefcase.roll",
            "kid": "figure.and.child.holdinghands",
            "elevator": "arrow.up.arrow.down.circle.fill",
            "golf": "figure.golf",
            "pet": "pawprint.fill",
            "ironing": "tshirt.fill"
        ]
        
        for (key, icon) in amenityIcons {
            if amenity.lowercased().contains(key) {
                return icon
            }
        }
        
        return "minus"
    }
    
}

#Preview {
    let images: [PropertyImage] = [
        PropertyImage(thumbnail: "https://lh4.googleusercontent.com/proxy/s-RFGSHRMbUWSwLbxeCY3ijpxX6OoBHoExMAwcZ6tdjyNKL44aK_gJrpHvNdR9cQRFbyb9-W8SbAhrK9gpt8tUtS6gqPwkEPqpoknjliG2kX7M5evJauC38f5hXUDSIZiKcy8BAwRiXUMWN4vH__iFawyItcOA=s287-w287-h192-n-k-no-v1", originalImage: "https://q-xx.bstatic.com/xdata/images/hotel/max1440x1080/100191168.jpg?k=85965c206e01a5f5ea647ad310ac7c84ded47fc580a6baea6496abfa2f2dd858&o="),
        PropertyImage(thumbnail: "https://lh4.googleusercontent.com/proxy/2Clj0TAo8MAT3ygyimKV8mCjbsnlrctkb4TYzTcYjR3MV-q3Crvgf3CLzWwY_YoA9VwObWRnt_kyCdWQoZ6me7j-k9_k6Zh44naFlC9NhQlW49uFXBtUYCQ50CrRSpWsQlqXEFx6XQZarYr6CS9vrOnspczk_Q=s287-w287-h192-n-k-no-v1", originalImage: "https://q-xx.bstatic.com/xdata/images/hotel/max1440x1080/87113043.jpg?k=26b4e8cec33bc111b793d709c3bc8ab7bd34f1ede9b93bec720dd7f148930503&o="),
        PropertyImage(thumbnail: "https://lh6.googleusercontent.com/proxy/vz40gGHRI3iGd3T79OoN9Z8QnVoj_MiO1B64txFkSe0hlv4MUcc8WQarN-TajLyY8r0G_2mhoUDQagAyeat3BXvbC42gyLS5ve5ra4nlD553Ho78YBgYauA4HHk-AyIMVnsTb_B4aY-a1zGH2La78yJVkcnkaA=s287-w287-h192-n-k-no-v1", originalImage: "https://q-xx.bstatic.com/xdata/images/hotel/max1440x1080/101832229.jpg?k=10e284ff673b117575e18a55c4adbac75a3a475304a5e3b2c6cdcb625dbb478b&o="),
        PropertyImage(thumbnail: "https://lh5.googleusercontent.com/proxy/ywf-YryyJAKkwSZAJF4T4g33CqkGJFeD4O8Ni1BZmwTXYy-XSwOSsheN73lW2AISXWazTHIFJJEaSQsONG81BCIZ2SYFXKAf61RNwdSiW2-X6qK-wj408QYI42jnYXfpfact1XjzslTSPDVMxQMAz4jov-0PPQ=s287-w287-h192-n-k-no-v1", originalImage: "https://q-xx.bstatic.com/xdata/images/hotel/max1440x1080/87113041.jpg?k=b8be8fe1d640efab46a4025af7a6766e50711c570fd2ceb4b657e5afbdf500b1&o="),
        PropertyImage(thumbnail: "https://lh3.googleusercontent.com/proxy/PoOOeeuwWjNoMBTYaTzcyzQYSa8B0B1KWXMtjnblRvU6YQnu2buiL7b99dV0K1P6lEbr4gxRQItpueOWTvpUutE42jQNEp6OCm85YCXqyQl9483XGI2mzmFs8_cqkZ2jV1ewCw4_jLykt4ooslZO9JgNdKC0ww=s287-w287-h192-n-k-no-v1", originalImage: "https://q-xx.bstatic.com/xdata/images/hotel/max1440x1080/101832226.jpg?k=eeecba394167428ca107e37488c93ea5c63f7548f804e890d7358a27133c3c53&o="),
        PropertyImage(thumbnail: "https://lh4.googleusercontent.com/proxy/BSVoyfL_9ZgLH7MWtQ0iljR1VlFdWo8vA49k3cznO68P7oUkNkYr3V2bp7iar4LHbd1tJMYX9Q65DcKoboyj6adxAb0fVn2l54s4cTkj2Fq-4AKULUq5Yt8I2mFodzb3GnUvIwZPzn2cU7cxCawANOrAY_xh-g=s287-w287-h192-n-k-no-v1", originalImage: "https://q-xx.bstatic.com/xdata/images/hotel/max1440x1080/101832224.jpg?k=3aa571479222e1f8134714a968cdb87480df5172df30cca25df3327376d17510&o="),
        PropertyImage(thumbnail: "https://lh5.googleusercontent.com/proxy/zFMn7qACckgRpyozGnkeToVLKg3cFWUH4im8Fcvnqj98M2_K6nmXhnhfx_7ONIRHD8X_Ach4CysJEsVN_a1DC-TxuShkwUoo39z-vdjgBo_cREkb4cR6CfItMRfEBephdm7es8koyf71CFJea7ZcfVsVoESvNA=s287-w287-h192-n-k-no-v1", originalImage: "https://q-xx.bstatic.com/xdata/images/hotel/max1440x1080/87109112.jpg?k=cd26a8a738927ac91438710ec15ea7c6a93761e64b5017f38f09f2bd359bc5c3&o="),
        PropertyImage(thumbnail: "https://lh6.googleusercontent.com/proxy/k06rXDTc9aOQwRSjWlUWA1cf7uQMq0L_wquhVYvXh23bZB6JDqzDFWGIs6UdMGIcTl33OngRfShazkFGUecEnG9BNMpzBkIrl2NKhxF9QHiqQUSxW8uiR3d7Rpzk3EOwMBf5MqgbZV39HTstc4gK-XY-9tpcC8M=s287-w287-h192-n-k-no-v1", originalImage: "https://q-xx.bstatic.com/xdata/images/hotel/max1440x1080/87112300.jpg?k=d53e7c3c9fc8485308138cbfb498e4d338a0cd81b2d08e22227dfc1376db5414&o=")
    ]

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
        images: images,
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
