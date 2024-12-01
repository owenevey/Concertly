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
    
    @State private var selectedFlight: FlightItem? = nil
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        HidingHeaderView (
            header: {
                FlightsHeader(viewModel: viewModel, fromDate: $viewModel.fromDate, toDate: $viewModel.toDate, fromAirport: $viewModel.fromAirport, toAirport: $viewModel.toAirport)
            },
            filtersBar: {
                FlightsFiltersBar(sortMethod: $viewModel.sortFlightsMethod, airlines: $viewModel.airlineFilter, stopsFilter: $viewModel.stopsFilter, priceFilter: $viewModel.priceFilter, flightPrices: viewModel.flightPrices, durationFilter: $viewModel.durationFilter, flightDurations: viewModel.flightDurations, timeFilter: $viewModel.timeFilter, flightTimes: viewModel.flightTimes)
            },
            scrollContent: {
                VStack(spacing: 15) {
                    if let outboundFlight = viewModel.outboundFlight {
                        HStack {
                            Text("Departing Flight")
                                .font(Font.custom("Barlow-SemiBold", size: 18))
                            
                            Button {
                                viewModel.outboundFlight = nil
                            } label: {
                                Text("Remove")
                                    .font(Font.custom("Barlow-SemiBold", size: 14))
                            }
                            
                            Spacer()
                            
                        }
                        FlightCard(flightItem: outboundFlight)
                        Text("Returning Flights")
                            .font(Font.custom("Barlow-SemiBold", size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("Departing Flights")
                            .font(Font.custom("Barlow-SemiBold", size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if viewModel.flightsResponse.status == Status.loading {
                        Text("Loading")
                    } else if viewModel.flightsResponse.status == Status.success {
                        if viewModel.filteredFlights.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "airplane.departure")
                                    .font(.system(size: 20))
                                
                                Text("No flights")
                                    .font(Font.custom("Barlow-Regular", size: 18))
                            }
                            .frame(height: 300)
                        } else {
                            ForEach(viewModel.filteredFlights) { flightItem in
                                FlightCard(flightItem: flightItem)
                                    .onTapGesture {
                                        selectedFlight = flightItem
                                        isSheetPresented = true
                                    }
                            }
                        }
                    }
                    
                    
                }
                .padding(15)
            }
        )
        .onChange(of: viewModel.fromDate) {
            concertViewModel.tripStartDate = viewModel.fromDate
        }
        .onChange(of: viewModel.toDate) {
            concertViewModel.tripEndDate = viewModel.toDate
        }
        .sheet(isPresented: Binding(
            get: { isSheetPresented && selectedFlight != nil },
            set: { isSheetPresented = $0 }
        )) {
            if let flight = selectedFlight {
                FlightDetailsView(flightItem: flight, outboundFlight: $viewModel.outboundFlight)
                    .presentationDetents([.large])
                    .presentationBackground(Color("Background"))
            }
        }
    }
    
    
}

#Preview {
    let concertViewModel = ConcertViewModel(concert: hotConcerts[0])
    
    FlightsView(concertViewModel: concertViewModel)
}
