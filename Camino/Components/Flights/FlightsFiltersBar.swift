import SwiftUI

struct FlightsFiltersBar: View {
    
    @Binding var sortMethod: SortFlightsEnum
    @Binding var airlines: [String: (imageURL: String, isEnabled: Bool)]
    @Binding var stopsFilter: FilterStopsEnum
    
    @Binding var timeFilter: Int
    var flightTimes: [Int]
    
    @Binding var durationFilter: Int
    var flightDurations: [Int]
    
    @Binding var priceFilter: Int
    var flightPrices: [Int]
    
    @State var presentSheet = false
    @State var detentHeight: CGFloat = 400
    @State var selectedFilter: FlightFilter
    
    init(sortMethod: Binding<SortFlightsEnum>, airlines: Binding<[String: (imageURL: String, isEnabled: Bool)]>, stopsFilter: Binding<FilterStopsEnum>, priceFilter: Binding<Int>, flightPrices: [Int], durationFilter: Binding<Int>, flightDurations: [Int], timeFilter: Binding<Int>, flightTimes: [Int]) {
        self._sortMethod = sortMethod
        self._airlines = airlines
        self._stopsFilter = stopsFilter
        
        self._priceFilter = priceFilter
        self.flightPrices = flightPrices
        
        self._durationFilter = durationFilter
        self.flightDurations = flightDurations
        
        self._timeFilter = timeFilter
        self.flightTimes = flightTimes
        
        self._selectedFilter = State(initialValue: .sort(sortMethod))
    }
    
    private func isFilterActive(_ filter: FlightFilter) -> Bool {
        switch filter {
        case.sort:
            return sortMethod != SortFlightsEnum.recommended
        case .airlines:
            return airlines.contains { !$0.value.isEnabled }
        case .stops:
            return stopsFilter != FilterStopsEnum.any
        case .price:
            let maxPrice = flightPrices.max() ?? 0
            return priceFilter < maxPrice
        case .duration:
            let maxDuration = flightDurations.max() ?? 0
            return durationFilter < maxDuration
        case .time:
            let maxTime = flightTimes.max() ?? 0
            return timeFilter < maxTime
        }
    }
    
    private var isAnyFilterActive: Bool {
        FlightFilter.allCases(
            sortMethod: $sortMethod,
            airlines: $airlines,
            stopsFilter: $stopsFilter,
            priceFilter: $priceFilter,
            flightPrices: flightPrices,
            durationFilter: $durationFilter,
            flightDurations: flightDurations,
            timeFilter: $timeFilter,
            flightTimes: flightTimes
        ).contains { isFilterActive($0) } }
    
    private func resetFilters() {
        sortMethod = .recommended
        
        for airline in airlines.keys {
            airlines[airline]?.isEnabled = true
        }
        
        stopsFilter = .any
        
        priceFilter = flightPrices.max() ?? Int.max
        
        durationFilter = flightDurations.max() ?? Int.max
        
        timeFilter = flightTimes.max() ?? Int.max
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(FlightFilter.allCases(sortMethod: $sortMethod, airlines: $airlines, stopsFilter: $stopsFilter, priceFilter: $priceFilter, flightPrices: flightPrices, durationFilter: $durationFilter, flightDurations: flightDurations, timeFilter: $timeFilter, flightTimes: flightTimes), id: \.title) { filter in
                        Button {
                            selectedFilter = filter
                            presentSheet = true
                        } label: {
                            HStack {
                                if filter.title == "Sort" {
                                    Image(systemName: "line.3.horizontal.decrease")
                                }
                                Text(filter.title)
                                    .font(.system(size: 14, type: .Regular))
                            }
                            .padding(13)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(isFilterActive(filter) ? Color.primary : .gray2, style: StrokeStyle(lineWidth: 2))
                                    .padding(2)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    if isAnyFilterActive {
                        Button {
                            withAnimation {
                                resetFilters()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "xmark")
                                
                                Text("Clear")
                                    .font(.system(size: 14, type: .Regular))
                            }
                            .padding(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .transition(.opacity)
                        
                    }
                    
                    
                    
                }
                .padding(10)
                .sheet(isPresented: $presentSheet) {
                    selectedFilter.destinationView
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
            Divider()
                .frame(height: 1)
                .overlay(.gray2)
        }
        .frame(height: 65)
        .background(Color.foreground)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    @Previewable @State var airlines = [
        "American": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/AA.png", isEnabled: true),
        "Delta": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/DL.png", isEnabled: true),
        "Frontier": (imageURL: "https://www.gstatic.com/flights/airline_logos/70px/F9.png", isEnabled: false)
    ]
    
    @Previewable @State var sortMethod: SortFlightsEnum = .cheapest
    @Previewable @State var stopsFilter: FilterStopsEnum = .any
    @Previewable @State var priceFilter = 300
    @Previewable @State var durationFilter = 300
    @Previewable @State var timeFilter = 300
    
    let flightDurations = [10, 20, 30, 50, 60, 120]
    let flightPrices = [100, 200, 300, 400, 500]
    let flightTimes = [6, 9, 12, 15, 18, 21]
    
    return VStack {
        Spacer()
        FlightsFiltersBar(
            sortMethod: $sortMethod,
            airlines: $airlines,
            stopsFilter: $stopsFilter,
            priceFilter: $priceFilter,
            flightPrices: flightPrices,
            durationFilter: $durationFilter,
            flightDurations: flightDurations,
            timeFilter: $timeFilter,
            flightTimes: flightTimes
        )
        Spacer()
    }
    .background(Color.gray3)
}
