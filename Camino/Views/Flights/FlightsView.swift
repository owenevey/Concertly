import SwiftUI

struct FlightsView: View {
    
    @StateObject private var viewModel: FlightsViewModel
    @ObservedObject var concertViewModel: ConcertViewModel
    
    init(concertViewModel: ConcertViewModel) {
        self.concertViewModel = concertViewModel
        _viewModel = StateObject(wrappedValue: FlightsViewModel(
            flightData: Binding<FlightInfo>(
                get: { concertViewModel.flightsResponse.data ?? FlightInfo() },
                set: { concertViewModel.flightsResponse.data = $0 }
            ),
            fromAirport: $concertViewModel.fromAirport,
            toAirport: $concertViewModel.toAirport,
            fromDate: $concertViewModel.tripStartDate,
            toDate: $concertViewModel.tripEndDate
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
                        TopNavBar(flightData: $viewModel.flightData, fromDate: $viewModel.fromDate, toDate: $viewModel.toDate, fromAirport: $viewModel.fromAirport, toAirport: $viewModel.toAirport)
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
                    // Populate selectedAirlines when the view appears
                    viewModel.airlineFilter = extractAirlineData(from: viewModel.flightData)
                }
            }
            
            else {
                // Fallback on earlier versions
            }
        }
    }
    
    func extractAirlineData(from flightData: FlightInfo) -> [String: (imageURL: String, isEnabled: Bool)] {
        var airlineDict: [String: (imageURL: String, isEnabled: Bool)] = [:]
        
        // Loop through all the best flights
        for flightItem in flightData.bestFlights {
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
        
        for flightItem in flightData.otherFlights {
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
        
        @Binding var flightData: FlightInfo
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
                VStack {
                    HStack {
                        Text("\(fromAirport) - \(toAirport)")
                            .font(Font.custom("Barlow-Bold", size: 20))
                        
                    }
                    Text("\(shorterFormat(fromDate)) - \(shorterFormat(toDate))")
                        .font(Font.custom("Barlow-SemiBold", size: 15))
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

func shorterFormat(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    
    return formatter.string(from: date)
}


let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm" // Adjust this format to match your JSON date format
    return formatter
}()

func loadFlightData(fileName: String) -> FlightInfo {
    guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "txt") else {
        fatalError("File not found")
    }
    
    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        
        // Set the date decoding strategy
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let flightData = try decoder.decode(FlightInfo.self, from: data)
        return flightData
    } catch {
        fatalError("Failed to load data: \(error.localizedDescription)")
    }
}

//#Preview {
//
//    @Previewable @State var flightData: FlightInfo = loadFlightData(fileName: "testFlightsResponse")
//    @Previewable @State var fromAirport: String = "AUS"
//    @Previewable @State var toAirport: String = "JFK"
//    @Previewable @State var fromDate: Date = Date.now
//    @Previewable @State var toDate: Date = Date.now
//
//    return FlightsView(flightData: <#T##FlightInfo#>, fromAirport: <#T##String#>, toAirport: <#T##String#>, fromDate: <#T##Date#>, toDate: <#T##Date#>, viewModel: <#T##arg#>, naturalScrollOffset: <#T##CGFloat#>, lastNaturalOffset: <#T##CGFloat#>, headerOffset: <#T##CGFloat#>, isScrollingUp: <#T##Bool#>)
//}
