import SwiftUI
import MapKit

struct ConcertView: View {
    
    
    
    var concert: Concert
    
    @State var flights: FlightInfo = FlightInfo()
    @State var hasAppeared: Bool = false
    @State var tripStartDate: Date
    @State var tripEndDate: Date
    @State var fromAirport: String = "AUS"
    @State var toAirport: String = "SYD"
    
    
    var flightsPrice: Int {
        flights.bestFlights.first?.price ?? 0
    }
    
    var hotelPrice: Int {
        270
    }
    
    var ticketPrice: Int {
        Int(concert.minPrice)
    }
    
    var totalPrice: Int {
        ticketPrice + hotelPrice + flightsPrice
    }
    
    init(concert: Concert) {
        self.concert = concert
        
        let calendar = Calendar.current
        self.tripStartDate = calendar.date(byAdding: .day, value: -1, to: concert.dateTime)!
        self.tripEndDate = calendar.date(byAdding: .day, value: 1, to: concert.dateTime)!
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ImageHeaderScrollView(imageUrl: concert.imageUrl) {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(concert.name)
                            .font(Font.custom("Barlow-Bold", size: 30))
                        
                        Text(concert.dateTime.formatted(date: .complete, time: .omitted))
                            .font(Font.custom("Barlow-SemiBold", size: 17))
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Minimum Price Summary")
                            .font(Font.custom("Barlow-SemiBold", size: 20))
                        
                        Text("\(tripStartDate.mediumFormat()) - \(tripEndDate.mediumFormat())")
                            .font(Font.custom("Barlow-SemiBold", size: 17))
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    VStack(spacing: 15) {
                        ForEach((LineItemType.allCases(fromDate: $tripStartDate, toDate: $tripEndDate, fromAirport: $fromAirport, toAirport: $toAirport, flightInfo: $flights, link: concert.url)), id: \.title) { item in
                            switch item {
                            case .flights:
                                LineItem(item: item, price: flightsPrice)
                            case .hotel:
                                LineItem(item: item, price: hotelPrice)
                                
                            case .ticket:
                                LineItem(item: item, price: ticketPrice)
                            }
                        }
                        
                        Divider()
                            .frame(height: 2)
                            .overlay(.customGray)
                        
                        HStack {
                            Text("Total:")
                                .font(Font.custom("Barlow-SemiBold", size: 17))
                            Spacer()
                            Text("$\(totalPrice)")
                                .font(Font.custom("Barlow-SemiBold", size: 17))
                        }
                        .padding(.horizontal, 10)
                        
                    }
                    
                    MapCard(concert: concert)
                        .padding(.vertical, 10)
                    
                    Button {
                        print("Plan trip tapped")
                    } label: {
                        Text("Plan Trip")
                            .font(Font.custom("Barlow-SemiBold", size: 18))
                            .padding()
                        
                            .containerRelativeFrame(.horizontal) { size, axis in
                                size - 100
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.accent)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(15)
                .background(Color("Background"))
                
                .containerRelativeFrame(.horizontal) { size, axis in
                    size
                }
            }
            
            
        }
        .background(Color("Background"))
        .ignoresSafeArea(edges: .top)
        .onAppear {
            if !hasAppeared {
                let calendar = Calendar.current
                tripStartDate = calendar.date(byAdding: .day, value: -1, to: concert.dateTime)!
                tripEndDate = calendar.date(byAdding: .day, value: 1, to: concert.dateTime)!
                
                Task {
                    do {
                        flights = try await getFlights(lat: concert.latitude, long: concert.longitude, fromAirport: "AUS", fromDate: tripStartDate.traditionalFormat(), toDate: tripEndDate.traditionalFormat())
                    } catch {
                        print("Error fetching flights: \(error)")
                    }
                }
                
                hasAppeared = true
            }
        }
    }
    
    
    private func headerView() -> some View {
        AsyncImage(url: URL(string: concert.imageUrl)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(height: 300) // Adjust height as needed
                .clipped()
        } placeholder: {
            Color.gray
                .frame(height: 300) // Placeholder height
        }
    }
    
    
}

#Preview {
    NavigationStack {
        ConcertView(concert: hotConcerts[0])
            .navigationBarHidden(true)
    }
}

