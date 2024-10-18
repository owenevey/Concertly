import SwiftUI

struct FlightCard: View {
    
    let flightItem: FlightItem
    
    var body: some View {
        VStack(spacing: 10) {
            
            HStack {
                VStack {
                    HStack {
                        AsyncImage(url: URL(string: flightItem.airlineLogo)) { image in
                            image
                                .resizable()
                        } placeholder: {
                            Image(systemName: "photo.fill")
                        }
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        
                        VStack(spacing: 2) {
                            HStack {
                                Text(timeFormat(flightItem.flights[0].arrivalAirport.time))
                                    .font(Font.custom("Barlow-SemiBold", size: 18))
                                    .frame(width: 60)
                                
                                Divider()
                                    .frame(height: 1)
                                    .frame(maxWidth: .infinity)
                                    .overlay(.gray)
                                
                                Text(timeFormat(flightItem.flights[0].departureAirport.time))
                                    .font(Font.custom("Barlow-SemiBold", size: 18))
                                    .frame(width: 60)
                            }
                            .frame(maxWidth: .infinity)
                            
                            HStack {
                                Text("SAN")
                                    .font(Font.custom("Barlow-Regular", size: 14))
                                    .frame(width: 60)
                                
                                Spacer()
                                Text("3h 45m")
                                    .font(Font.custom("Barlow-Regular", size: 14))
                                    .foregroundStyle(.gray)
                                Spacer()
                                
                                Text("SAN")
                                    .font(Font.custom("Barlow-Regular", size: 14))
                                    .frame(width: 60)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    
                    //                    HStack {
                    //                        AsyncImage(url: URL(string: airlineLogo)) { image in
                    //                            image
                    //                                .resizable()
                    //                        } placeholder: {
                    //                            Image(systemName: "photo.fill")
                    //                        }
                    //                        .scaledToFit()
                    //                        .frame(width: 20, height: 20)
                    //
                    //                        VStack(spacing: 2) {
                    //                            HStack {
                    //                                Text(startTime+"a")
                    //                                    .font(Font.custom("Barlow-SemiBold", size: 18))
                    //                                    .frame(width: 60)
                    //
                    //                                Divider()
                    //                                    .frame(height: 1)
                    //                                    .frame(maxWidth: .infinity)
                    //                                    .overlay(.gray)
                    //
                    //                                Text(startTime+"p")
                    //                                    .font(Font.custom("Barlow-SemiBold", size: 18))
                    //                                    .frame(width: 60)
                    //                            }
                    //                            .frame(maxWidth: .infinity)
                    //
                    //                            HStack {
                    //                                Text("SAN")
                    //                                    .font(Font.custom("Barlow-Regular", size: 14))
                    //                                    .frame(width: 60)
                    //
                    //                                Spacer()
                    //                                Text("3h 45m")
                    //                                    .font(Font.custom("Barlow-Regular", size: 14))
                    //                                    .foregroundStyle(.gray)
                    //                                Spacer()
                    //
                    //                                Text("SAN")
                    //                                    .font(Font.custom("Barlow-Regular", size: 14))
                    //                                    .frame(width: 60)
                    //                            }
                    //                            .frame(maxWidth: .infinity)
                    //                        }
                    //                    }
                }
                
                Text("$\(flightItem.price)")
                    .font(Font.custom("Barlow-SemiBold", size: 25))
                    .frame(width: 100)
            }
            
            Divider()
                .frame(height: 1)
                .overlay(.customGray)
                .padding(.horizontal, -14)
            
            HStack{
                Text(flightItem.flights[0].airline)
                    .font(Font.custom("Barlow-Regular", size: 16))
                    .foregroundStyle(.gray)
                Spacer()
                
                
            }
            
            
        }
        .padding(15)
        .clipShape(RoundedRectangle(cornerRadius: 20))
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
