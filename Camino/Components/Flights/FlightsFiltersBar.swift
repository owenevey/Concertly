import SwiftUI

struct FlightsFiltersBar: View {
    
    @Binding var allAirlines: [String: (imageURL: String, isEnabled: Bool)]
    @State var presentSheet = false
    @State var selectedFilter: FlightFilter = FlightFilter.sort
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(FlightFilter.allCases(airlines: $allAirlines), id: \.title) { filter in
                        Button {
                            selectedFilter = filter
                            presentSheet = true
                        } label: {
                            HStack {
                                if filter.title == "Sort" {
                                    Image(systemName: "line.3.horizontal.decrease")
                                }
                                Text(filter.title)
                                    .font(Font.custom("Barlow-Regular", size: 15))
                            }
                            .padding(13)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.customGray, style: StrokeStyle(lineWidth: 2))
                                    .padding(2)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .sheet(isPresented: $presentSheet) {
                        selectedFilter.destinationView
                            .presentationDetents([.medium])
                    }
                }
                .padding(10)
            }
            Divider()
                .frame(height: 1)
                .overlay(.customGray)
        }
        .background(Color("Card"))
        .frame(height: 65)
    }
}

#Preview {
    @Previewable @State var airlines = [
        "American": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/AA.png", isEnabled: true),
        "Delta": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/DL.png", isEnabled: true),
        "Frontier": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/F9.png", isEnabled: false)
    ]
    
    VStack {
        Spacer()
        FlightsFiltersBar(allAirlines: $airlines)
        Spacer()
    }
    .background(.gray)
}
