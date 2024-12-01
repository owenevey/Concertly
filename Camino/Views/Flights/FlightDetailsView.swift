import SwiftUI

struct FlightDetailsView: View {
    @Environment(\.dismiss) var dismiss
    let flightItem: FlightItem
    
    @Binding var outboundFlight: FlightItem?
    
    var body: some View {
        ScrollView {
            
            HStack {
                VStack(alignment: .leading) {
                    Circle()
                        .fill(.white)
                        .frame(width: 50, height: 50)
                        .overlay(
                            AsyncImage(url: URL(string: flightItem.flights.first!.airlineLogo)) { image in
                                image
                                    .resizable()
                            } placeholder: {
                                Image(systemName: "photo.fill")
                            }
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        )
                    
                    Text("\(flightItem.flights.first!.departureAirport.id) - \(flightItem.flights.last!.arrivalAirport.id)")
                        .font(Font.custom("Barlow-SemiBold", size: 18))
                    
                    Text("December 29, 2024")
                        .font(Font.custom("Barlow-Regular", size: 18))
                    
                }
                
                
                Spacer()
                
                VStack {
                    Spacer()
                    Text(flightItem.price, format: .currency(code: "USD").precision(.fractionLength(0)))
                        .font(Font.custom("Barlow-SemiBold", size: 23))
                }
            }
            .padding(.top, 50)
            .padding(.horizontal)
            
            Divider()
                .frame(height: 2)
                .overlay(.customGray)
            
            Button {
                outboundFlight = flightItem
                dismiss()
            } label: {
                Text("Select Flight")
                    .font(Font.custom("Barlow-SemiBold", size: 18))
                    .padding(10)
                    .frame(width: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.accent)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            
            ForEach(flightItem.flights.indices, id: \.self) { index in
                FlightLeg(flight: flightItem.flights[index])
                
                if index < flightItem.layovers?.count ?? 0 {
                    LayoverView(layover: flightItem.layovers![index])
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 16))
                        .frame(width: 20)
                    Text("Total Duration: \(minsToHrMins(minutes: flightItem.totalDuration))")
                        .font(Font.custom("Barlow-Regular", size: 16))
                }
                
                HStack {
                    Image(systemName: "airplane.departure")
                        .font(.system(size: 16))
                        .frame(width: 20)
                    Text("Departure Airport: \(flightItem.flights.first!.departureAirport.name)")
                        .font(Font.custom("Barlow-Regular", size: 16))
                }
                
                HStack {
                    Image(systemName: "airplane.arrival")
                        .font(.system(size: 16))
                        .frame(width: 20)
                    Text("Arrival Airport: \(flightItem.flights.last!.arrivalAirport.name)")
                        .font(Font.custom("Barlow-Regular", size: 16))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            
        }
        .background(Color("Background"))
    }
}


struct LayoverView: View {
    let layover: Layover
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "clock")
                .font(.system(size: 16))
                .foregroundStyle(.gray)
            Text("\(minsToHrMins(minutes: layover.duration)) Layover at \(layover.id)")
                .font(Font.custom("Barlow-Regular", size: 15))
                .foregroundStyle(.gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}


struct FlightLeg: View {
    
    var flight: Flight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Circle()
                    .fill(.white)
                    .frame(width: 40, height: 40)
                    .overlay(
                        AsyncImage(url: URL(string: flight.airlineLogo)) { image in
                            image
                                .resizable()
                        } placeholder: {
                            Image(systemName: "photo.fill")
                        }
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    )
                
                
                VStack(alignment: .leading) {
                    Text(flight.airline)
                        .font(Font.custom("Barlow-SemiBold", size: 18))
                    Text(flight.flightNumber)
                        .font(Font.custom("Barlow-SemiBold", size: 15))
                        .foregroundStyle(.gray)
                }
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(flight.departureAirport.time.timeFormat())
                            .font(Font.custom("Barlow-Regular", size: 20))
                        Text(flight.departureAirport.time.meridiemFormat())
                            .font(Font.custom("Barlow-Regular", size: 15))
                            .padding(.bottom, 2)
                    }
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.up.right.circle.fill")
                            .font(.system(size: 13))
                        Text(flight.departureAirport.id)
                            .font(Font.custom("Barlow-Regular", size: 14))
                            .minimumScaleFactor(0.5)
                    }
                    
                }
                
                
                HStack(spacing: 5) {
                    Rectangle()
                        .frame(height: 2)
                        .overlay(Color.gray)
                    
                    Text(minsToHrMins(minutes: flight.duration))
                        .font(Font.custom("Barlow-SemiBold", size: 14))
                        .foregroundStyle(.gray)
                    
                    Rectangle()
                        .frame(height: 2)
                        .overlay(Color.gray)
                }
                
                
                VStack(alignment: .trailing, spacing: 0) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(flight.arrivalAirport.time.timeFormat())
                            .font(Font.custom("Barlow-Regular", size: 20))
                        Text(flight.arrivalAirport.time.meridiemFormat())
                            .font(Font.custom("Barlow-Regular", size: 15))
                            .padding(.bottom, 2)
                    }
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.down.right.circle.fill")
                            .font(.system(size: 13))
                        Text(flight.arrivalAirport.id)
                            .font(Font.custom("Barlow-Regular", size: 14))
                            .minimumScaleFactor(0.5)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "airplane")
                        .font(.system(size: 16))
                        .frame(width: 20)
                    Text(flight.airplane)
                        .font(Font.custom("Barlow-Regular", size: 16))
                }
                
                HStack {
                    Image(systemName: "ticket.fill")
                        .font(.system(size: 16))
                        .frame(width: 20)
                    Text(flight.travelClass)
                        .font(Font.custom("Barlow-Regular", size: 16))
                }
                
                HStack {
                    Image(systemName: "carseat.right.fill")
                        .font(.system(size: 16))
                        .frame(width: 20)
                    Text("\(flight.legroom) legroom")
                        .font(Font.custom("Barlow-Regular", size: 16))
                }
            }
            
            
        }
        .padding()
    }
}


#Preview {
    // JSON Data
    let jsonData = """
    {
        "flights": [
            {
                "departure_airport": {
                    "name": "Austin-Bergstrom International Airport",
                    "id": "AUS",
                    "time": "2024-10-20 06:39"
                },
                "arrival_airport": {
                    "name": "Charlotte Douglas International Airport",
                    "id": "CLT",
                    "time": "2024-10-20 10:18"
                },
                "duration": 159,
                "airplane": "Boeing 737",
                "airline": "American",
                "airline_logo": "https://www.gstatic.com/flights/airline_logos/70px/AA.png",
                "travel_class": "Economy",
                "flight_number": "AA 2549",
                "legroom": "30 in",
                "extensions": [
                    "Average legroom (30 in)",
                    "Wi-Fi for a fee",
                    "In-seat power & USB outlets",
                    "Stream media to your device",
                    "Carbon emissions estimate: 151 kg"
                ]
            },
            {
                "departure_airport": {
                    "name": "Charlotte Douglas International Airport",
                    "id": "CLT",
                    "time": "2024-10-20 11:10"
                },
                "arrival_airport": {
                    "name": "John F. Kennedy International Airport",
                    "id": "JFK",
                    "time": "2024-10-20 13:23"
                },
                "duration": 133,
                "airplane": "Boeing 737",
                "airline": "American",
                "airline_logo": "https://www.gstatic.com/flights/airline_logos/70px/AA.png",
                "travel_class": "Economy",
                "flight_number": "AA 2908",
                "legroom": "30 in",
                "extensions": [
                    "Average legroom (30 in)",
                    "Wi-Fi for a fee",
                    "In-seat power & USB outlets",
                    "Stream media to your device",
                    "Carbon emissions estimate: 101 kg"
                ]
            }
        ],
        "layovers": [
            {
                "duration": 52,
                "name": "Charlotte Douglas International Airport",
                "id": "CLT"
            }
        ],
        "total_duration": 344,
        "carbon_emissions": {
            "this_flight": 253000,
            "typical_for_this_route": 225000,
            "difference_percent": 12
        },
        "price": 630,
        "type": "Round trip",
        "airline_logo": "https://www.gstatic.com/flights/airline_logos/70px/AA.png",
        "extensions": [
            "Checked baggage for a fee",
            "Bag and fare conditions depend on the return flight"
        ],
        "departure_token": "WyJDalJJY2s5T1JGcFdTeTFvVUdkQlFVOTFXbmRDUnkwdExTMHRMUzB0TFhCbWFITXhPRUZCUVVGQlIyTkZWemhCUldkdmNVRkJFZzFCUVRJMU5EbDhRVUV5T1RBNEdnc0k0dXNERUFJYUExVlRSRGdjY09MckF3PT0iLFtbIkFVUyIsIjIwMjQtMTAtMjAiLCJDTFQiLG51bGwsIkFBIiwiMjU0OSJdLFsiQ0xUIiwiMjAyNC0xMC0yMCIsIkpGSyIsbnVsbCwiQUEiLCIyOTA4Il1dXQ=="
    }
    """.data(using: .utf8)!
    
    // Decode the JSON into a FlightItem
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMddHHmm)
    let flightItem = try! decoder.decode(FlightItem.self, from: jsonData)
    
    // Mock State for the @Binding
    @State var outboundFlight: FlightItem? = nil
    
    // Use the decoded FlightItem in the preview
    return FlightDetailsView(flightItem: flightItem, outboundFlight: $outboundFlight)
}


extension DateFormatter {
    static let yyyyMMddHHmm: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
}

