import SwiftUI

struct HotelsHeader: View {
    
    @Binding var fromDate: Date
    @Binding var toDate: Date
    @Binding var location: String
    
    let calendar = Calendar.current
    @State var detentHeight: CGFloat = 274
    
    @State var presentSheet = false
    
    var body: some View {
        HStack {
            BackButton()
                .frame(width: 80, alignment: .leading)
            
            VStack {
                Text(location)
                    .font(.system(size: 18, type: .SemiBold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity)
                
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
            .frame(width: 80, alignment: .trailing)
        }
        .frame(height: 60)
        .background(Color.foreground)
        .sheet(isPresented: $presentSheet) {
            EditHotelsSearch(fromDate: $fromDate, toDate: $toDate, location: $location)
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
//            bestFlights: [],
//            otherFlights: [],
//            airports: mockAirports
//        )
//    )
//
//    VStack {
//        Spacer()
//        HotelsHeader(
//            viewModel: FlightsViewModel(fromDate: fromDate, toDate: toDate, flightsResponse: flightsResponse),
//            fromDate: .constant(fromDate),
//            toDate: .constant(toDate),
//            fromAirport: .constant(fromAirport),
//            toAirport: .constant(toAirport)
//        )
//        Spacer()
//    }
//    .background(.gray3)
//}
//
