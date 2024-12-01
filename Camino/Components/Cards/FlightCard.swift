import SwiftUI

struct FlightCard: View {
    
    let flightItem: FlightItem
    
    var layoverText: String {
        if flightItem.flights.count == 1 {
            return "Nonstop"
        } else if flightItem.flights.count == 2 {
            return "1 Layover"
        } else {
            return "\(flightItem.flights.count) Layovers"
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .top) {
                HStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 40, height: 40)
                        .overlay(
                            AsyncImage(url: URL(string: flightItem.flights.first!.airlineLogo)) { image in
                                image
                                    .resizable()
                            } placeholder: {
                                Image(systemName: "photo.fill")
                            }
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                        )
                    
                    
                    VStack(alignment: .leading) {
                        Text(flightItem.flights.first!.airline)
                            .font(Font.custom("Barlow-SemiBold", size: 18))
                        Text(flightItem.flights.first!.airplane ?? "")
                            .font(Font.custom("Barlow-SemiBold", size: 15))
                            .foregroundStyle(.gray)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 5) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                    
                    Text(minsToHrMins(minutes: flightItem.totalDuration))
                        .font(Font.custom("Barlow-SemiBold", size: 14))
                        .foregroundStyle(.gray)
                }
            }
            
            HStack {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .bottom, spacing: 0) {
                            Text(flightItem.flights.first!.departureAirport.time.timeFormat())
                                .font(Font.custom("Barlow-SemiBold", size: 20))
                            Text(flightItem.flights.first!.departureAirport.time.meridiemFormat())
                                .font(Font.custom("Barlow-SemiBold", size: 15))
                                .padding(.bottom, 2)
                        }
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.up.right.circle.fill")
                                .font(.system(size: 13))
                            Text(flightItem.flights.first!.departureAirport.id)
                                .font(Font.custom("Barlow-SemiBold", size: 14))
                                .minimumScaleFactor(0.5)
                        }
                        
                    }
                    
                    
                    HStack(spacing: 0) {
                        Rectangle()
                            .frame(height: 2)
                            .overlay(Color.gray)
                        
                        ForEach(1..<flightItem.flights.count, id: \.self) { _ in
                            Circle()
                                .stroke(.gray, lineWidth: 2)
                                .frame(width: 8, height: 8)
                            Rectangle()
                                .frame(height: 2)
                                .overlay(Color.gray)
                        }
                    }
                    
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        HStack(alignment: .bottom, spacing: 0) {
                            Text(flightItem.flights.last!.arrivalAirport.time.timeFormat())
                                .font(Font.custom("Barlow-SemiBold", size: 20))
                            Text(flightItem.flights.last!.arrivalAirport.time.meridiemFormat())
                                .font(Font.custom("Barlow-SemiBold", size: 15))
                                .padding(.bottom, 2)
                        }
                        HStack(spacing: 5) {
                            Image(systemName: "arrow.down.right.circle.fill")
                                .font(.system(size: 13))
                            Text(flightItem.flights.last!.arrivalAirport.id)
                                .font(Font.custom("Barlow-SemiBold", size: 14))
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
                Text(flightItem.price, format: .currency(code: "USD").precision(.fractionLength(0)))
                    .font(Font.custom("Barlow-SemiBold", size: 23))
                    .frame(width: 100)
            }
        }
        .padding(15)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.card)
                .stroke(.customGray, style: StrokeStyle(lineWidth: 1))
        )
        
        
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
    
    let mockFlightItem = FlightItem(
        flights: [mockFlight],
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
        departureToken: "WyJDalJJY2s5T1JGcFdTeTFvVUdkQlFVOTFXbmRDUnkwdExTMHRMUzB0TFhCbWFITXhPRUZCUVVGQlIyTkZWemhCUldkdmNVRkJFZ1pCUVRJeU9EY2FDd2pjdEFNUUFob0RWVk5FT0J4dzNMUUQiLFtbIkFVUyIsIjIwMjQtMTAtMjAiLCJKRksiLG51bGwsIkFBIiwiMjI4NyJdXV0="
    )
    
    FlightCard(flightItem: mockFlightItem)
        .padding()
}
