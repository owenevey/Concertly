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
                        Text(flightItem.flights.first!.airplane)
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
            
            //////////
            
            HStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(flightItem.flights.first!.departureAirport.time.timeFormat())
                            .font(Font.custom("Barlow-SemiBold", size: 30))
                        Text(flightItem.flights.first!.departureAirport.time.meridiemFormat())
                            .font(Font.custom("Barlow-SemiBold", size: 20))
                            .padding(.bottom, 2)
                    }
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.up.right.circle.fill")
                            .font(.system(size: 14))
                        Text(flightItem.flights.first!.departureAirport.id)
                            .font(Font.custom("Barlow-SemiBold", size: 14))
                            .minimumScaleFactor(0.5)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                Image(systemName: "airplane")
                Spacer()
                
                VStack(alignment: .trailing) {
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(flightItem.flights.last!.arrivalAirport.time.timeFormat())
                            .font(Font.custom("Barlow-SemiBold", size: 30))
                        Text(flightItem.flights.last!.arrivalAirport.time.meridiemFormat())
                            .font(Font.custom("Barlow-SemiBold", size: 20))
                            .padding(.bottom, 2)
                    }
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.down.right.circle.fill")
                            .font(.system(size: 14))
                        Text(flightItem.flights.last!.arrivalAirport.id)
                            .font(Font.custom("Barlow-SemiBold", size: 14))
                            .minimumScaleFactor(0.5)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            
            Divider()
                .frame(height: 1)
                .overlay(.gray)
            
            HStack {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                    Text("\(flightItem.flights.first!.arrivalAirport.time.shortFormat()) - \(layoverText)")
                        .font(Font.custom("Barlow-SemiBold", size: 14))
                        .foregroundStyle(.gray)
                }
                Spacer()
                Text(flightItem.price, format: .currency(code: "USD").precision(.fractionLength(0)))
                    .font(Font.custom("Barlow-SemiBold", size: 20))
            }
            
            
            
            
            
        }
        .padding(15)
        .contentShape(RoundedRectangle(cornerRadius: 20))
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.card)
                .shadow(color: .black.opacity(0.2), radius: 5)
        )
        
    }
    
    func timeFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // Format to show hours and minutes with AM/PM
        return formatter.string(from: date)
    }
}


#Preview {
    let mockFlightData = loadFlightData(fileName: "testFlightsResponse")
    return NavigationStack {
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 15) {
                FlightCard(flightItem: mockFlightData.bestFlights[0])
                FlightCard(flightItem: mockFlightData.bestFlights[1])
                FlightCard(flightItem: mockFlightData.bestFlights[2])
            }
            .padding(.horizontal, 15)
        }
        .navigationTitle("Flights")
    }
}
