import SwiftUI

struct FlightsHeader: View {
    
    @Binding var fromAirport: String
    @Binding var toAirport: String
    @Binding var fromDate: Date
    @Binding var toDate: Date
    
    let calendar = Calendar.current
    
    @State var presentSheet = false
    @State var detentHeight: CGFloat = 339
    
    var toAirportHeader: String {
        if toAirport.isEmpty {
            return "Loading"
        }
        return "\(fromAirport) - \(toAirport)"
    }
    
    var body: some View {
        HStack {
            BackButton()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Text(toAirportHeader)
                    .font(.system(size: 18, type: .SemiBold))
                
                Text("\(fromDate.shortFormat()) - \(toDate.shortFormat())")
                    .font(.system(size: 14, type: .Medium))
            }
            
            Button {
                presentSheet = true
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                    
                    Text("Edit")
                        .font(.system(size: 16, type: .Medium))
                        .padding(.trailing, 20)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(height: 60)
        .background(Color.foreground)
        .sheet(isPresented: $presentSheet) {
            EditFlightsSearch(fromAirport: $fromAirport, toAirport: $toAirport, fromDate: $fromDate, toDate: $toDate)
                .readHeight()
                .onPreferenceChange(BottomSheetHeightPreferenceKey.self) { height in
                    if let height {
                        self.detentHeight = height
                    }
                }
                .presentationDetents([.height(self.detentHeight)])
                .presentationBackground(Color.background)
        }
    }
}

//#Preview {
//    let fromDate = Date()
//    let toDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
//    let fromAirport = "JFK"
//    let toAirport = "LAX"
//
//    let mockAirports = [
//        AirportInfo(
//            departure: [
//                AirportDetail(
//                    airport: AirportSummary(id: "JFK", name: "John F. Kennedy International"),
//                    city: "New York",
//                    country: "USA",
//                    countryCode: "US",
//                    image: "",
//                    thumbnail: ""
//                )
//            ],
//            arrival: [
//                AirportDetail(
//                    airport: AirportSummary(id: "LAX", name: "Los Angeles International"),
//                    city: "Los Angeles",
//                    country: "USA",
//                    countryCode: "US",
//                    image: "",
//                    thumbnail: ""
//                )
//            ]
//        )
//    ]
//
//    let flightsResponse = ApiResponse(
//        status: .success,
//        data: FlightsResponse(
//            flights: [],
//            airports: mockAirports
//        )
//    )
//
//    VStack {
//        Spacer()
//        FlightsHeader(
//            fromAirport: .constant(fromAirport),
//            toAirport: .constant(toAirport),
//            fromDate: .constant(fromDate),
//            toDate: .constant(toDate)
//        )
//        Spacer()
//    }
//    .background(.gray3)
//}

