import SwiftUI

struct FlightsView<T: TripViewModelProtocol>: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var tripViewModel: T
    @StateObject var viewModel: FlightsViewModel
    
    init(tripViewModel: T) {
        self.tripViewModel = tripViewModel
        
        _viewModel = StateObject(wrappedValue: FlightsViewModel(
            fromDate: tripViewModel.tripStartDate,
            toDate: tripViewModel.tripEndDate,
            flightsResponse: tripViewModel.flightsResponse
        ))
    }
    
    @State private var selectedFlight: FlightItem? = nil
    
    var body: some View {
        HidingHeaderView (
            header: {
                FlightsHeader(fromAirport: $viewModel.fromAirport, toAirport: $viewModel.toAirport, fromDate: $viewModel.fromDate, toDate: $viewModel.toDate)
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
        LazyVStack(spacing: 15) {
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
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.departingFlight = nil
                            }
                        } label: {
                            Text("Remove")
                                .font(.system(size: 16, type: .Regular))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    FlightCard(flightItem: departingFlight)
                        .shadow(color: .black.opacity(0.05), radius: 5)
                        .onTapGesture {
                            selectedFlight = departingFlight
                        }
                    
                    Text("Returning Flights")
                        .font(.system(size: 18, type: .SemiBold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 5)
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
                    .transition(.opacity)
            }
            else if viewModel.flightsResponse.status == Status.success {
                if viewModel.filteredFlights.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "airplane.departure")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                        
                        Text("No flights")
                            .font(.system(size: 18, type: .Regular))
                    }
                    .frame(height: 250)
                    .transition(.opacity)
                } else {
                    ForEach(viewModel.filteredFlights) { flightItem in
                        FlightCard(flightItem: flightItem)
                            .shadow(color: .black.opacity(0.05), radius: 5)
                            .transition(.opacity)
                            .onTapGesture {
                                selectedFlight = flightItem
                            }
                    }
                    .transition(.opacity)
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
                .transition(.opacity)
            }
        }
        .padding(15)
    }
    
    private func handleDepartingFlightChange() {
        if viewModel.departingFlight != nil {
            Task {
                await viewModel.getReturningFlights()
            }
            tripViewModel.flightsResponse = viewModel.flightsResponse
            tripViewModel.flightsPrice = viewModel.flightsResponse.data?.flights.first?.price ?? 0
        } else {
            refetchDepartingFlights()
        }
    }
    
    private func handleReturningFlightChange() {
        tripViewModel.flightsPrice = viewModel.returningFlight?.price ?? 0
        dismiss()
    }
    
    private func refetchDepartingFlights() {
        Task {
            await viewModel.getDepartingFlights()
        }
        tripViewModel.flightsResponse = viewModel.flightsResponse
        tripViewModel.flightsPrice = viewModel.flightsResponse.data?.flights.first?.price ?? 0
    }
    
    private func handleDateChange() {
        tripViewModel.tripStartDate = viewModel.fromDate
        tripViewModel.tripEndDate = viewModel.toDate
        refetchDepartingFlights()
        Task {
            await tripViewModel.getHotels()
        }
    }
}

#Preview {
    NavigationStack {
        ConcertView(concert: hotConcerts[0])
            .navigationBarHidden(true)
    }
}
