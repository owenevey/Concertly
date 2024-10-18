import SwiftUI

struct FlightsView: View {
    
    @State var flightData: FlightInfo
    let fromDate: Date?
    let toDate: Date?
    
    @State var flights: [FlightItem] = []
    
    @State var selectedAirlines: [String: Bool] = [
        "American": true,
        "Delta": false,
        "Frontier": true,
        "JetBlue": false
    ]
    
    var filteredFlights: [FlightItem] {
        return flightData.bestFlights + flightData.otherFlights
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
                        ForEach(filteredFlights) { flightItem in
                            FlightCard(flightItem: flightItem)
                        }
                    }
                    .padding(15)
                }
                .background(Color("Background"))
                .safeAreaInset(edge: .top, spacing: 0) {
                    VStack(spacing: 0) {
                        TopNavBar()
                            .zIndex(1)
                        FiltersBar(selectedAirlines: $selectedAirlines)
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
            }
            
            else {
                // Fallback on earlier versions
            }
        }
    }
}


struct FiltersBar: View {
    
    @Binding var selectedAirlines: [String: Bool]
    @State var presentSheet = false
    @State var selectedFilter: FlightFilter = FlightFilter.sort
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(FlightFilter.allCases(airlines: $selectedAirlines), id: \.title) { filter in
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


struct TopNavBar: View {
    
    @Environment(\.dismiss) var dismiss
    
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
                    Text("SYD - LAX")
                        .font(Font.custom("Barlow-Bold", size: 20))
                    
                }
                Text("Oct 9 - Oct 17")
                    .font(Font.custom("Barlow-SemiBold", size: 15))
            }
            Spacer()
            HStack {
                Spacer()
                HStack {
                    Text("Edit")
                        .font(Font.custom("Barlow-SemiBold", size: 16))
                    
                    Image(systemName: "pencil")
                        .font(.system(size: 20))
                        .padding(.trailing, 20)
                }
            }
            .frame(maxWidth: .infinity)
        }
        //        .frame(height: 70)
        .padding(.bottom, 5)
        .background(Color("Card"))
    }
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

#Preview {
    let mockFlightData = loadFlightData(fileName: "testFlightsResponse")
    return FlightsView(flightData: mockFlightData, fromDate: Date.now, toDate: Date.now)
}
