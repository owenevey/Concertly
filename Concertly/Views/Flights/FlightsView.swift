import SwiftUI
import GoogleMobileAds

struct FlightsView<T: TripViewModelProtocol>: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var tripViewModel: T
    @StateObject var viewModel: FlightsViewModel<T>
    
    init(tripViewModel: T) {
        self.tripViewModel = tripViewModel
        
        _viewModel = StateObject(wrappedValue: FlightsViewModel(
            tripViewModel: tripViewModel,
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
        .onChange(of: viewModel.returningFlight) { handleReturningFlightChange() }
        
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
                    returningFlight: $viewModel.returningFlight,
                    viewModel: viewModel
                )
                .presentationDetents([.large])
                .presentationBackground(Color.background)
            }
        }
        .navigationBarHidden(true)
    }
    
    let adSize = currentOrientationAnchoredAdaptiveBanner(width: UIScreen.main.bounds.width - 40)
    
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
                            .font(.system(size: 17, type: .Regular))
                    }
                    .frame(height: 250)
                    .transition(.opacity)
                } else {
                    LazyVStack(spacing: 15) {
                        ForEach(Array(viewModel.filteredFlights.enumerated()), id: \.offset) { index, flightItem in
                            VStack {
                                FlightCard(flightItem: flightItem)
                                    .shadow(color: .black.opacity(0.05), radius: 5)
                                    .transition(.opacity)
                                    .onTapGesture {
                                        selectedFlight = flightItem
                                    }
                                
                                if index != 0 && (index % 7) == 0 {
                                    BannerViewContainer(adSize, adUnitID: AdUnitIds.flightsBanner.rawValue)
                                        .frame(height: adSize.size.height)
                                        .padding(.vertical, 5)
                                }
                            }
                        }
                    }
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
    
    private func handleReturningFlightChange() {
        tripViewModel.flightsPrice = viewModel.returningFlight?.price ?? -1
        dismiss()
    }
}

#Preview {
    NavigationStack {
        ConcertView(concert: hotConcerts[0])
    }
}
