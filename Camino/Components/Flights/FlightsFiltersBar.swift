import SwiftUI

struct FlightsFiltersBar: View {
    
    @Binding var sortMethod: SortFlightsEnum
    @Binding var allAirlines: [String: (imageURL: String, isEnabled: Bool)]
    @Binding var stopsFilter: FilterStopsEnum
    @Binding var durationFilter: Int
    var flightDurations: [Int]
    @Binding var priceFilter: Int
    var flightPrices: [Int]
    @State var presentSheet = false
    @State var selectedFilter: FlightFilter
    
    init(sortMethod: Binding<SortFlightsEnum>, allAirlines: Binding<[String: (imageURL: String, isEnabled: Bool)]>, stopsFilter: Binding<FilterStopsEnum>, durationFilter: Binding<Int>, flightDurations: [Int], priceFilter: Binding<Int>, flightPrices: [Int]) {
        self._sortMethod = sortMethod
        self._allAirlines = allAirlines
        self._selectedFilter = State(initialValue: .sort(sortMethod))
        self._stopsFilter = stopsFilter
        self._durationFilter = durationFilter
        self.flightDurations = flightDurations
        self._priceFilter = priceFilter
        self.flightPrices = flightPrices
    }
    
    private func isFilterActive(_ filter: FlightFilter) -> Bool {
            switch filter {
            case.sort:
                return sortMethod != SortFlightsEnum.cheapest
            case .airlines:
                        return allAirlines.contains { !$0.value.isEnabled }
            case .stops:
                return stopsFilter != FilterStopsEnum.any
            case .duration:
                let maxDuration = flightDurations.max() ?? Int.max
                return durationFilter < maxDuration
            case .price:
                let maxPrice = flightPrices.max() ?? Int.max
                return priceFilter < maxPrice
            default:
                return false
            }
        }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(FlightFilter.allCases(airlines: $allAirlines, sortMethod: $sortMethod, stopsFilter: $stopsFilter, durationFilter: $durationFilter, flightDurations: flightDurations, priceFilter: $priceFilter, flightPrices: flightPrices), id: \.title) { filter in
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
                                    .stroke(isFilterActive(filter) ? Color.primary : .customGray, style: StrokeStyle(lineWidth: 2))
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
    
    let flightDurations = [1,2,3,4,44,55,66,77,88,99]
    
    VStack {
        Spacer()
        FlightsFiltersBar(sortMethod: .constant(.cheapest), allAirlines: $airlines, stopsFilter: .constant(.any), durationFilter: .constant(300), flightDurations: flightDurations, priceFilter: .constant(300), flightPrices: flightDurations)
        Spacer()
    }
    .background(.gray)
}
