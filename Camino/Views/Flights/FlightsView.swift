import SwiftUI

struct FlightsView: View {
    
    @Environment(\.dismiss) var dismiss
    
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
                    if let departingFlight = viewModel.departingFlight {
                        HStack(alignment: .center) {
                            Text("Departing Flight")
                                .font(.system(size: 18, type: .SemiBold))
                            
                            Button {
                                viewModel.departingFlight = nil
                            } label: {
                                Text("Remove")
                                    .font(.system(size: 16, type: .Regular))
                            }
                            Spacer()
                        }
                        
                        FlightCard(flightItem: departingFlight)
                            .onTapGesture {
                                selectedFlight = departingFlight
                                isSheetPresented = true
                            }
                        
                        Text("Returning Flights")
                            .font(.system(size: 18, type: .SemiBold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    else {
                        Text("Departing Flights")
                            .font(.system(size: 18, type: .SemiBold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if viewModel.flightsResponse.status == Status.loading {
                        LoadingView()
                            .frame(height: 250)
                    }
                    else if viewModel.flightsResponse.status == Status.success {
                        if viewModel.filteredFlights.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "airplane.departure")
                                    .font(.system(size: 20))
                                
                                Text("No flights")
                                    .font(.system(size: 18, type: .Regular))
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
                    } else if viewModel.flightsResponse.status == Status.error {
                        ErrorView(text: "Error fetching flights", action: {
                            if viewModel.departingFlight == nil {
                                await viewModel.getDepartingFlights()
                            } else {
                                await viewModel.getReturningFlights()
                            }
                        })
                        .frame(height: 250)
                    }
                    
                    
                }
                .padding(15)
            }
        )
        
        .onChange(of: viewModel.departingFlight) {
            if viewModel.departingFlight != nil {
                Task {
                    await viewModel.getReturningFlights()
                }
            } else {
                Task {
                    await viewModel.getDepartingFlights()
                }
            }
        }
        .onChange(of: viewModel.returningFlight) {
            concertViewModel.flightsPrice = viewModel.returningFlight?.price ?? 0
            dismiss()
        }
        .onChange(of: viewModel.fromDate) {
            concertViewModel.tripStartDate = viewModel.fromDate
            Task {
                await viewModel.getDepartingFlights()
            }
            concertViewModel.flightsPrice = viewModel.flightsResponse.data?.bestFlights.first?.price ?? 0
        }
        .onChange(of: viewModel.toDate) {
            concertViewModel.tripEndDate = viewModel.toDate
            Task {
                await viewModel.getDepartingFlights()
            }
            concertViewModel.flightsPrice = viewModel.flightsResponse.data?.bestFlights.first?.price ?? 0
        }
        .onChange(of: viewModel.fromAirport) {
            Task {
                await viewModel.getDepartingFlights()
            }
            concertViewModel.flightsPrice = viewModel.flightsResponse.data?.bestFlights.first?.price ?? 0
        }
        .onChange(of: viewModel.toAirport) {
            Task {
                await viewModel.getDepartingFlights()
            }
            concertViewModel.flightsPrice = viewModel.flightsResponse.data?.bestFlights.first?.price ?? 0
        }
        
        .sheet(isPresented: Binding(
            get: { isSheetPresented && selectedFlight != nil },
            set: { isSheetPresented = $0 }
        )) {
            if let flight = selectedFlight {
                FlightDetailsView(flightItem: flight, departingFlight: $viewModel.departingFlight, returningFlight: $viewModel.returningFlight)
                    .presentationDetents([.large])
                    .presentationBackground(Color.background)
            }
        }
    }
    
    
}

#Preview {
    let concertViewModel = ConcertViewModel(concert: hotConcerts[0])
    
    FlightsView(concertViewModel: concertViewModel)
}
