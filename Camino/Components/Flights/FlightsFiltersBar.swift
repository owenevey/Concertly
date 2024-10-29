import SwiftUI

struct FlightsFiltersBar: View {
    
    @Binding var sortMethod: SortFlightsEnum
    @Binding var allAirlines: [String: (imageURL: String, isEnabled: Bool)]
    @Binding var stopsFilter: FilterStopsEnum
    @Binding var durationFilter: Int
    var durationRange: DurationRange
    @State var presentSheet = false
    @State var selectedFilter: FlightFilter
    
    init(sortMethod: Binding<SortFlightsEnum>, allAirlines: Binding<[String: (imageURL: String, isEnabled: Bool)]>, stopsFilter: Binding<FilterStopsEnum>, durationFilter: Binding<Int>, durationRange: DurationRange) {
        self._sortMethod = sortMethod
        self._allAirlines = allAirlines
        self._selectedFilter = State(initialValue: .sort(sortMethod))
        self._stopsFilter = stopsFilter
        self._durationFilter = durationFilter
        self.durationRange = durationRange
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(FlightFilter.allCases(airlines: $allAirlines, sortMethod: $sortMethod, stopsFilter: $stopsFilter, durationFilter: $durationFilter, durationRange: durationRange), id: \.title) { filter in
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
                            .presentationBackground(Color("Background"))
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
    
    let durationRange = DurationRange(min: 0, max: 600)
    
    VStack {
        Spacer()
        FlightsFiltersBar(sortMethod: .constant(.cheapest), allAirlines: $airlines, stopsFilter: .constant(.any), durationFilter: .constant(300), durationRange: durationRange)
        Spacer()
    }
    .background(.gray)
}
