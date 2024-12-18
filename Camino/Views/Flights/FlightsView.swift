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
    
    var body: some View {
        HidingHeaderView (
            header: {
                FlightsHeader(viewModel: viewModel, fromDate: $viewModel.fromDate, toDate: $viewModel.toDate, fromAirport: $viewModel.fromAirport, toAirport: $viewModel.toAirport)
            },
            filtersBar: {
                FlightsFiltersBar(sortMethod: $viewModel.sortFlightsMethod, airlines: $viewModel.airlineFilter, stopsFilter: $viewModel.stopsFilter, priceFilter: $viewModel.priceFilter, flightPrices: viewModel.flightPrices, durationFilter: $viewModel.durationFilter, flightDurations: viewModel.flightDurations, timeFilter: $viewModel.arrivalTimeFilter, flightTimes: viewModel.flightArrivalTimes)
            },
            scrollContent: {
                mainContent
            }
        )
        .onChange(of: viewModel.departingFlight) { handleDepartingFlightChange() }
        .onChange(of: viewModel.returningFlight) { handleReturningFlightChange() }
        .onChange(of: viewModel.fromDate) { handleDateChange() }
        .onChange(of: viewModel.toDate) { handleDateChange() }
        .onChange(of: viewModel.fromAirport) { refetchDepartingFlights() }
        .onChange(of: viewModel.toAirport) { refetchDepartingFlights() }
        
        .sheet(isPresented: Binding<Bool>(
            get: { selectedFlight != nil },
            set: { isPresented in
                if !isPresented {
                    selectedFlight = nil
                }
            }
        )) {
            if let flight = selectedFlight {
                FlightDetailsView(
                    flightItem: flight,
                    departingFlight: $viewModel.departingFlight,
                    returningFlight: $viewModel.returningFlight
                )
                .presentationDetents([.large])
                .presentationBackground(Color.background)
            }
        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 15) {
            if viewModel.flightsResponse.status == .success || viewModel.departingFlight != nil {
                if let prices = viewModel.priceInsights {
                    PriceInsightsCard(insights: prices)
                        .transition(.opacity)
                }
            }
            
            Group {
                if let departingFlight = viewModel.departingFlight {
                    HStack {
                        Text("Departing Flight")
                            .font(.system(size: 18, type: .SemiBold))
                        
                        Button {
                            withAnimation(.easeInOut) {
                                viewModel.departingFlight = nil
                            }
                        } label: {
                            Text("Remove")
                                .font(.system(size: 16, type: .Regular))
                        }
                        Spacer()
                    }
                    
                    FlightCard(flightItem: departingFlight)
                        .onTapGesture {
                            selectedFlight = departingFlight
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
            }
            .transition(.opacity)
            
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
                    .frame(height: 250)
                } else {
                    ForEach(viewModel.filteredFlights) { flightItem in
                        FlightCard(flightItem: flightItem)
                            .transition(.opacity)
                            .onTapGesture {
                                selectedFlight = flightItem
                            }
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: viewModel.filteredFlights)
                }
            }
            else if viewModel.flightsResponse.status == Status.error {
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
    
    private func handleDepartingFlightChange() {
        if viewModel.departingFlight != nil {
            Task {
                await viewModel.getReturningFlights()
            }
            concertViewModel.flightsResponse = viewModel.flightsResponse
            concertViewModel.flightsPrice = viewModel.flightsResponse.data?.bestFlights.first?.price ?? 0
        } else {
            refetchDepartingFlights()
        }
    }
    
    private func handleReturningFlightChange() {
        concertViewModel.flightsPrice = viewModel.returningFlight?.price ?? 0
        dismiss()
    }
    
    private func refetchDepartingFlights() {
        Task {
            await viewModel.getDepartingFlights()
        }
        concertViewModel.flightsResponse = viewModel.flightsResponse
        concertViewModel.flightsPrice = viewModel.flightsResponse.data?.bestFlights.first?.price ?? 0
    }
    
    private func handleDateChange() {
        concertViewModel.tripStartDate = viewModel.fromDate
        concertViewModel.tripEndDate = viewModel.toDate
        refetchDepartingFlights()
    }
}

#Preview {
    let concertViewModel = ConcertViewModel(concert: hotConcerts[0])
    
    FlightsView(concertViewModel: concertViewModel)
}
