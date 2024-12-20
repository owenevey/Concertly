import SwiftUI

struct FlightsHeader: View {
    
    @Binding var fromDate: Date
    @Binding var toDate: Date
    @Binding var fromAirport: String
    @Binding var toAirport: String
    
    let calendar = Calendar.current
    
    @State var presentSheet = false
    
    var body: some View {
        HStack {
            TranslucentBackButton()
            
            VStack {
                Text("\(fromAirport) - \(toAirport)")
                    .font(.system(size: 18, type: .SemiBold))
                
                Text("\(fromDate.shortFormat()) - \(toDate.shortFormat())")
                    .font(.system(size: 14, type: .Medium))
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Button {
                    presentSheet = true
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16))
                        
                        Text("Edit")
                            .font(.system(size: 16, type: .Medium))
                            .padding(.trailing, 20)
                    }
                }
            }
        }
        .frame(height: 60)
        .background(Color.foreground)
        .sheet(isPresented: $presentSheet) {
            EditFlightsSearch(fromDate: $fromDate, toDate: $toDate, fromAirport: $fromAirport, toAirport: $toAirport)
                .presentationDetents([.medium])
                .presentationBackground(Color.background)
        }
    }
}

#Preview {
    let fromDate = Date()
    let toDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
    let fromAirport = "JFK"
    let toAirport = "LAX"
    
    let mockAirports = [
        AirportInfo(
            departure: [
                AirportDetail(
                    airport: AirportSummary(id: "JFK", name: "John F. Kennedy International"),
                    city: "New York",
                    country: "USA",
                    countryCode: "US",
                    image: "",
                    thumbnail: ""
                )
            ],
            arrival: [
                AirportDetail(
                    airport: AirportSummary(id: "LAX", name: "Los Angeles International"),
                    city: "Los Angeles",
                    country: "USA",
                    countryCode: "US",
                    image: "",
                    thumbnail: ""
                )
            ]
        )
    ]
    
    let flightsResponse = ApiResponse(
        status: .success,
        data: FlightsResponse(
            bestFlights: [],
            otherFlights: [],
            airports: mockAirports
        )
    )
    
    VStack {
        Spacer()
        FlightsHeader(
            fromDate: .constant(fromDate),
            toDate: .constant(toDate),
            fromAirport: .constant(fromAirport),
            toAirport: .constant(toAirport)
        )
        Spacer()
    }
    .background(.gray3)
}

