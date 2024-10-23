import SwiftUI

struct FlightsView: View {
    
    @ObservedObject var concertViewModel: ConcertViewModel
    @StateObject var viewModel: FlightsViewModel
    
    init(concertViewModel: ConcertViewModel) {
        self.concertViewModel = concertViewModel
        
        _viewModel = StateObject(wrappedValue: FlightsViewModel(
            fromDate: concertViewModel.tripStartDate,
            toDate: concertViewModel.tripEndDate,
            flightsResponse: concertViewModel.flightsResponse
        ))
    }
    
    @State private var naturalScrollOffset: CGFloat = 0
    @State private var lastNaturalOffset: CGFloat = 0
    @State private var headerOffset: CGFloat = 0
    @State private var isScrollingUp: Bool = false
    
    var body: some View {
        GeometryReader {
            
            let safeArea = $0.safeAreaInsets
            let headerHeight: CGFloat = 66
            
            if #available(iOS 18.0, *) {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.filteredFlights) { flightItem in
                            FlightCard(flightItem: flightItem)
                        }
                    }
                    .padding(15)
                }
                .background(Color("Background"))
                .safeAreaInset(edge: .top, spacing: 0) {
                    VStack(spacing: 0) {
                        TopNavBar(viewModel: viewModel, fromDate: $viewModel.fromDate, toDate: $viewModel.toDate, fromAirport: $viewModel.fromAirport, toAirport: $viewModel.toAirport)
                            .zIndex(1)
                        FiltersBar(allAirlines: $viewModel.airlineFilter)
                            .offset(y: -headerOffset)
                    }
                }
                .onScrollGeometryChange(for: CGFloat.self) { proxy in
                    let maxHeight = proxy.contentSize.height - proxy.containerSize.height
                    return max(min(proxy.contentOffset.y + (safeArea.top + 56) + headerHeight, maxHeight), 0)
                } action: { oldValue, newValue in
                    self.isScrollingUp = oldValue < newValue
                    headerOffset = min(max(newValue - lastNaturalOffset, 0), headerHeight)
                    
                    naturalScrollOffset = newValue
                }
                .onScrollPhaseChange({ oldPhase, newPhase in
                    if !newPhase.isScrolling && (headerOffset != 0 || headerOffset != headerHeight) {
                        withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                            if (headerOffset > (headerHeight * 0.5 ) && naturalScrollOffset > headerHeight) {
                                headerOffset = headerHeight
                            } else {
                                headerOffset = 0
                            }
                            lastNaturalOffset = naturalScrollOffset - headerOffset
                        }
                    }
                })
                .onChange(of: isScrollingUp, { oldValue, newValue in
                    lastNaturalOffset = naturalScrollOffset - headerOffset
                })
                .onAppear {
                    viewModel.airlineFilter = extractAirlineData(from: viewModel.flightsResponse.data)
                }
            }
            
            else {
                // Fallback on earlier versions
            }
        }
        .onChange(of: viewModel.fromDate) {
            concertViewModel.tripStartDate = viewModel.fromDate
        }
        .onChange(of: viewModel.toDate) {
            concertViewModel.tripEndDate = viewModel.toDate
        }
        
    }
    
    func extractAirlineData(from flightData: FlightsResponse?) -> [String: (imageURL: String, isEnabled: Bool)] {
        var airlineDict: [String: (imageURL: String, isEnabled: Bool)] = [:]
        
        guard let flights = flightData else {
            return airlineDict
        }
        
        // Loop through all the best flights
        for flightItem in flights.bestFlights {
            // Loop through the individual flights in each item
            for flight in flightItem.flights {
                let airlineName = flight.airline
                let airlineLogo = flight.airlineLogo
                
                // If the airline doesn't already exist in the dictionary, add it
                if airlineDict[airlineName] == nil {
                    airlineDict[airlineName] = (imageURL: airlineLogo, isEnabled: true)
                }
            }
        }
        
        for flightItem in flights.otherFlights {
            // Loop through the individual flights in each item
            for flight in flightItem.flights {
                let airlineName = flight.airline
                let airlineLogo = flight.airlineLogo
                
                // If the airline doesn't already exist in the dictionary, add it
                if airlineDict[airlineName] == nil {
                    airlineDict[airlineName] = (imageURL: airlineLogo, isEnabled: true)
                }
            }
        }
        
        return airlineDict
    }
    
    
    struct TopNavBar: View {
        
        @Environment(\.dismiss) var dismiss
        
        let viewModel: FlightsViewModel
        
        @Binding var fromDate: Date
        @Binding var toDate: Date
        @Binding var fromAirport: String
        @Binding var toAirport: String
        
        let calendar = Calendar.current
        
        var body: some View {
            HStack {
                HStack {
                    Button(action: {dismiss()}) {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "arrow.backward")
                                    .font(.system(size: 20))
                            )
                            .padding(.leading, 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                Spacer()
                Button {
                    // Call getFlights() here
                    Task {
                        await viewModel.getFlights() // This calls the method
                    }
                } label: {VStack {
                    HStack {
                        Text("\(fromAirport) - \(toAirport)")
                            .font(Font.custom("Barlow-Bold", size: 20))
                        
                    }
                    Text("\(fromDate.shortFormat()) - \(toDate.shortFormat())")
                        .font(Font.custom("Barlow-SemiBold", size: 15))
                }
                }
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        fromDate = calendar.date(byAdding: .day, value: -1, to: fromDate)!
                    } label: {
                        HStack(spacing: 5) {
                            Text("Edit")
                                .font(Font.custom("Barlow-SemiBold", size: 16))
                            
                            Image(systemName: "pencil")
                                .font(.system(size: 16))
                                .padding(.trailing, 20)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 5)
            .background(Color("Card"))
        }
    }
    
}


struct FiltersBar: View {
    
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
                    .onChange(of: selectedFilter) {
                        presentSheet = true
                    }
                    .sheet(isPresented: $presentSheet) {
                        selectedFilter.destinationView
                            .presentationDetents([.medium])
                    }
                }
                .padding(10)
            }.frame(height: 66)
            
            Divider()
                .frame(height: 1)
                .overlay(.customGray)
            
        }
        .frame(height: 69)
        .background(Color("Card"))
    }
}


#Preview {
    let concertViewModel = ConcertViewModel(concert: hotConcerts[0])
    
    FlightsView(concertViewModel: concertViewModel)
}
