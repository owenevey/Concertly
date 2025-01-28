import SwiftUI

struct FlightCard: View {
    
    let flightItem: FlightItem
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .center) {
                HStack {
                    if flightItem.flights.count > 1 && flightItem.flights[0].airline != flightItem.flights[1].airline {
                        VStack(spacing: 0) {
                            HStack {
                                Circle()
                                    .fill(.white)
                                    .stroke(.gray2, lineWidth: 1)
                                    .frame(width: 25, height: 25)
                                    .overlay(
                                        ImageLoader(url: flightItem.flights[1].airlineLogo, contentMode: .fit)
                                            .frame(width: 15, height: 15)
                                            .clipped()
                                    )
                                    .offset(y: 5)
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(.white)
                                    .stroke(.gray2, lineWidth: 1)
                                    .frame(width: 25, height: 25)
                                    .overlay(
                                        ImageLoader(url: flightItem.flights[0].airlineLogo, contentMode: .fit)
                                            .frame(width: 15, height: 15)
                                            .clipped()
                                    )
                                    .offset(y: -5)
                            }
                        }
                    }
                    else {
                        Circle()
                            .fill(.white)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Group {
                                    if let url = flightItem.flights.first?.airlineLogo {
                                        ImageLoader(url: url, contentMode: .fit)
                                            .frame(width: 25, height: 25)
                                            .clipped()
                                    } else {
                                        Color.clear
                                            .frame(width: 25, height: 25)
                                    }
                                }
                            )
                    }
                }
                .frame(width: 40, height: 40)
                
                
                VStack(alignment: .leading) {
                    if let flightNumber = flightItem.flights.first?.flightNumber {
                        Text(flightItem.flights.first?.airline ?? "")
                            .font(.system(size: 18, type: .Medium))
                        Text(flightNumber)
                            .font(.system(size: 16, type: .Regular))
                            .foregroundStyle(.gray3)
                    }
                    else {
                        Spacer()
                        Text(flightItem.flights.first?.airline ?? "")
                            .font(.system(size: 18, type: .Medium))
                        Spacer()
                    }
                    
                }
                
                Spacer()
                
                VStack {
                    HStack(spacing: 5) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray3)
                        
                        Text(minsToHrMins(minutes: flightItem.totalDuration))
                            .font(.system(size: 14, type: .Regular))
                            .foregroundStyle(.gray3)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .frame(height: 45)
            
            HStack {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .bottom, spacing: 0) {
                            Text(flightItem.flights.first?.departureAirport.time.timeFormat() ?? "")
                                .font(.system(size: 20, type: .Regular))
                            Text(flightItem.flights.first?.departureAirport.time.meridiemFormat() ?? "")
                                .font(.system(size: 15, type: .Regular))
                                .padding(.bottom, 2)
                        }
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.up.right.circle.fill")
                                .font(.system(size: 13))
                            Text(flightItem.flights.first?.departureAirport.id ?? "")
                                .font(.system(size: 14, type: .Regular))
                        }
                    }
                    
                    HStack(spacing: 0) {
                        Rectangle()
                            .frame(height: 2)
                            .overlay(Color.gray2)
                        
                        ForEach(1..<flightItem.flights.count, id: \.self) { _ in
                            Circle()
                                .stroke(.gray2, lineWidth: 2)
                                .frame(width: 8, height: 8)
                            Rectangle()
                                .frame(height: 2)
                                .overlay(Color.gray2)
                        }
                    }
                    
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        HStack(alignment: .bottom, spacing: 0) {
                            Text(flightItem.flights.last?.arrivalAirport.time.timeFormat() ?? "")
                                .font(.system(size: 20, type: .Regular))
                            Text(flightItem.flights.last?.arrivalAirport.time.meridiemFormat() ?? "")
                                .font(.system(size: 15, type: .Regular))
                                .padding(.bottom, 2)
                        }
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.down.right.circle.fill")
                                .font(.system(size: 13))
                            Text(flightItem.flights.last?.arrivalAirport.id ?? "")
                                .font(.system(size: 14, type: .Regular))
                        }
                    }
                }
                Text(flightItem.price, format: .currency(code: "USD").precision(.fractionLength(0)))
                    .font(.system(size: 25, type: .Medium))
                    .frame(width: 100)
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.foreground)
                .stroke(.gray2, style: StrokeStyle(lineWidth: 1))
                .padding(1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    func timeFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}


#Preview {
    let departureAirport = Airport(id: "AUS", name: "Austin-Bergstrom International Airport", time: DateFormatter().date(from: "2024-10-20 05:21") ?? Date())
    let arrivalAirport = Airport(id: "JFK", name: "John F. Kennedy International Airport", time: DateFormatter().date(from: "2024-10-20 10:05") ?? Date())
    
    let mockFlight = Flight(
        departureAirport: departureAirport,
        arrivalAirport: arrivalAirport,
        duration: 224,
        airplane: "Airbus A319",
        airline: "American",
        airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/AA.png",
        travelClass: "Economy",
        flightNumber: "AA 2287",
        legroom: "30 in",
        extensions: [
            "Average legroom (30 in)",
            "Wi-Fi for a fee",
            "In-seat power outlet",
            "Stream media to your device",
            "Carbon emissions estimate: 249 kg"
        ],
        oftenDelayedByOver30Min: false
    )
    
    let mockFlight2 = Flight(
        departureAirport: departureAirport,
        arrivalAirport: arrivalAirport,
        duration: 224,
        airplane: "Airbus A319",
        airline: "Southwest",
        airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/WN.png",
        travelClass: "Economy",
        flightNumber: "AA 2287",
        legroom: "30 in",
        extensions: [
            "Average legroom (30 in)",
            "Wi-Fi for a fee",
            "In-seat power outlet",
            "Stream media to your device",
            "Carbon emissions estimate: 249 kg"
        ],
        oftenDelayedByOver30Min: false
    )
    
    let mockFlightItem = FlightItem(
        flights: [mockFlight, mockFlight2],
        layovers: nil,
        totalDuration: 224,
        carbonEmissions: CarbonEmissions(thisFlight: 249000, typicalForThisRoute: 225000, differencePercent: 11),
        price: 559,
        type: "Round trip",
        airlineLogo: "https://www.gstatic.com/flights/airline_logos/70px/AA.png",
        extensions: [
            "Checked baggage for a fee",
            "Bag and fare conditions depend on the return flight"
        ],
        departureToken: "WyJDalJJY2s5T1JGcFdTeTFvVUdkQlFVOTFXbmRDUnkwdExTMHRMUzB0TFhCbWFITXhPRUZCUVVGQlIyTkZWemhCUldkdmNVRkJFZ1pCUVRJeU9EY2FDd2pjdEFNUUFob0RWVk5FT0J4dzNMUUQiLFtbIkFVUyIsIjIwMjQtMTAtMjAiLCJKRksiLG51bGwsIkFBIiwiMjI4NyJdXV0=", bookingToken: nil
    )
    
    FlightCard(flightItem: mockFlightItem)
        .padding()
}
