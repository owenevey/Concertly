import SwiftUI

struct FlightDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let flightItem: FlightItem
    
    @Binding var departingFlight: FlightItem?
    @Binding var returningFlight: FlightItem?
    
    var body: some View {
        
        VStack(spacing: 0) {
            VStack {
                HStack(alignment: .top) {
                    let uniqueAirlines = Array(Set(flightItem.flights.map { $0.airlineLogo }))
                    
                    ForEach(0..<uniqueAirlines.count, id: \.self) { index in
                        Circle()
                            .fill(.white)
                            .frame(width: 45, height: 45)
                            .overlay(
                                ImageLoader(url: uniqueAirlines[index], contentMode: .fit)
                                    .frame(width: 25, height: 25)
                                    .clipped()
                            )
                    }
                    Spacer()
                    BackButton(showBackground: true, showX: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        
                        Text("\(flightItem.flights.first?.departureAirport.id ?? "") - \(flightItem.flights.last?.arrivalAirport.id ?? "")")
                            .font(.system(size: 23, type: .SemiBold))
                        
                        Text(flightItem.flights.first?.departureAirport.time.mediumFormat() ?? "")
                            .font(.system(size: 18, type: .Regular))
                    }
                    
                    Spacer()
                    
                    Text(flightItem.price, format: .currency(code: "USD").precision(.fractionLength(0)))
                        .font(.system(size: 23, type: .Medium))
                }
            }
            .padding(15)
            
            Divider()
                .frame(height: 1.5)
                .overlay(.gray2)
                .padding(.horizontal, -15)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    ConcertlyButton(label: departingFlight == flightItem ? "Remove" : "Select Flight") {
                        if departingFlight == nil {
                            departingFlight = flightItem
                        } else if departingFlight == flightItem {
                            departingFlight = nil
                        } else {
                            returningFlight = flightItem
                        }
                        
                        dismiss()
                    }
                    
                    VStack(spacing: 10) {
                        Text("Itinerary")
                            .font(.system(size: 20, type: .SemiBold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 15) {
                            ForEach(flightItem.flights.indices, id: \.self) { index in
                                FlightLeg(flight: flightItem.flights[index])
                                
                                if let layovers = flightItem.layovers, index < layovers.count {
                                    LayoverView(layover: layovers[index])
                                }
                            }
                        }
                    }
                    
                    VStack(spacing: 10) {
                        Text("Route Details")
                            .font(.system(size: 20, type: .SemiBold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 5)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 16))
                                    .frame(width: 22)
                                Text("Total Duration: \(minsToHrMins(minutes: flightItem.totalDuration))")
                                    .font(.system(size: 16, type: .Regular))
                            }
                            
                            if let departureAirport = flightItem.flights.first?.departureAirport.name {
                                HStack {
                                    Image(systemName: "airplane.departure")
                                        .font(.system(size: 16))
                                        .frame(width: 22)
                                    Text("Departure Airport:\n\(departureAirport)")
                                        .font(.system(size: 16, type: .Regular))
                                }
                            }
                            
                            if let arrivalAirport = flightItem.flights.last?.arrivalAirport.name {
                                HStack {
                                    Image(systemName: "airplane.arrival")
                                        .font(.system(size: 16))
                                        .frame(width: 22)
                                    Text("Arrival Airport:\n\(arrivalAirport)")
                                        .font(.system(size: 16, type: .Regular))
                                }
                            }
                            
                        }
//                        .foregroundStyle(.gray3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(15)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.foreground)
                                .stroke(.gray2, style: StrokeStyle(lineWidth: 1))
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .padding(15)
            }
        }
        .background(Color.background)
    }
}


struct LayoverView: View {
    let layover: Layover
    
    var body: some View {
        HStack {
            Image(systemName: "clock.fill")
                .font(.system(size: 16))
                .foregroundStyle(.gray3)
            Text("\(minsToHrMins(minutes: layover.duration)) Layover at \(layover.id)")
                .font(.system(size: 16, type: .Regular))
                .foregroundStyle(.gray3)
        }
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
                        ImageLoader(url: flight.airlineLogo, contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .clipped()
                    )
                
                VStack(alignment: .leading) {
                    Text(flight.airline)
                        .font(.system(size: 18, type: .Medium))
                    Text(flight.flightNumber)
                        .font(.system(size: 16, type: .Regular))
                        .foregroundStyle(.gray3)
                }
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(flight.departureAirport.time.timeFormat())
                            .font(.system(size: 20, type: .Regular))
                        Text(flight.departureAirport.time.meridiemFormat())
                            .font(.system(size: 16, type: .Regular))
                    }
                    
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.up.right.circle.fill")
                            .font(.system(size: 13))
                        Text(flight.departureAirport.id)
                            .font(.system(size: 14, type: .Regular))
                    }
                }
                
                HStack(spacing: 5) {
                    Rectangle()
                        .frame(height: 2)
                        .overlay(Color.gray2)
                    
                    Text(minsToHrMins(minutes: flight.duration))
                        .font(.system(size: 14, type: .Regular))
                        .foregroundStyle(.gray3)
                    
                    Rectangle()
                        .frame(height: 2)
                        .overlay(Color.gray2)
                }
                
                
                VStack(alignment: .trailing, spacing: 0) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(flight.arrivalAirport.time.timeFormat())
                            .font(.system(size: 20, type: .Regular))
                        Text(flight.arrivalAirport.time.meridiemFormat())
                            .font(.system(size: 16, type: .Regular))
                    }
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.down.right.circle.fill")
                            .font(.system(size: 13))
                        Text(flight.arrivalAirport.id)
                            .font(.system(size: 14, type: .Regular))
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                if let airplane = flight.airplane {
                    HStack {
                        Image(systemName: "airplane")
                            .font(.system(size: 16))
                            .frame(width: 22)
                        Text(airplane)
                            .font(.system(size: 16, type: .Regular))
                    }
                }
                
                if let travelClass = flight.travelClass {
                    HStack {
                        Image(systemName: "ticket.fill")
                            .font(.system(size: 16))
                            .frame(width: 22)
                        Text(travelClass)
                            .font(.system(size: 16, type: .Regular))
                    }
                }
                
                if let legroom = flight.legroom {
                    HStack {
                        Image(systemName: "carseat.right.fill")
                            .font(.system(size: 16))
                            .frame(width: 22)
                        Text("\(legroom) legroom")
                            .font(.system(size: 16, type: .Regular))
                    }
                }
            }
            .foregroundStyle(.gray3)
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.foreground)
                .stroke(.gray2, style: StrokeStyle(lineWidth: 1))
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}


#Preview {
    @Previewable @State var departingFlight: FlightItem? = nil
    @Previewable @State var returningFlight: FlightItem? = nil
    
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
                "airline": "Alaska",
                "airline_logo": "https://www.gstatic.com/flights/airline_logos/70px/AS.png",
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
    
    
    // Use the decoded FlightItem in the preview
    return FlightDetailsView(flightItem: flightItem, departingFlight: $departingFlight, returningFlight: $returningFlight)
}


extension DateFormatter {
    static let yyyyMMddHHmm: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
}

