import SwiftUI

struct HotelsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var concertViewModel: ConcertViewModel
    @StateObject var viewModel: HotelsViewModel
    
    init(concertViewModel: ConcertViewModel) {
        self.concertViewModel = concertViewModel
        
        _viewModel = StateObject(wrappedValue: HotelsViewModel(
            location: concertViewModel.concert.generalLocation,
            fromDate: concertViewModel.tripStartDate,
            toDate: concertViewModel.tripEndDate,
            hotelsResponse: concertViewModel.hotelsResponse
        ))
    }
    
    
    var body: some View {
        HidingHeaderView (
            header: {
                HotelsHeader(fromDate: $viewModel.fromDate, toDate: $viewModel.toDate, location: $viewModel.location)
            },
            filtersBar: {
                HotelsFilterBar(priceFilter: $viewModel.priceFilter, hotelPrices: viewModel.hotelPrices)
            },
            scrollContent: {
                mainContent
            }
        )
        
        //        .sheet(isPresented: Binding<Bool>(
        //            get: { selectedFlight != nil },
        //            set: { isPresented in
        //                if !isPresented {
        //                    selectedFlight = nil
        //                }
        //            }
        //        )) {
        //            if let flight = selectedFlight {
        //                FlightDetailsView(
        //                    flightItem: flight,
        //                    departingFlight: $viewModel.departingFlight,
        //                    returningFlight: $viewModel.returningFlight
        //                )
        //                .presentationDetents([.large])
        //                .presentationBackground(Color.background)
        //            }
        //        }
    }
    
    private var mainContent: some View {
        VStack(spacing: 15) {
            
            if viewModel.hotelsResponse.status == Status.loading {
                LoadingView()
                    .frame(height: 250)
                    .transition(.opacity)
            }
            else if viewModel.hotelsResponse.status == Status.success {
                if viewModel.filteredHotels.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "bed.double.fill")
                            .font(.system(size: 20))
                        
                        Text("No hotels")
                            .font(.system(size: 18, type: .Regular))
                    }
                    .frame(height: 250)
                    .transition(.opacity)
                } else {
                    ForEach(viewModel.filteredHotels) { property in
                        HotelCard(property: property)
                            .shadow(color: .black.opacity(0.05), radius: 5)
                            .transition(.opacity)
//                            .onTapGesture {
//                                selectedFlight = flightItem
//                            }
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: viewModel.filteredHotels)
                }
            }
            else if viewModel.hotelsResponse.status == Status.error {
                ErrorView(text: "Error fetching hotels", action: {
                    await viewModel.getHotels()
                    
                })
                .frame(height: 250)
                .transition(.opacity)
            }
        }
        .padding(15)
    }
}

#Preview {
    let concertViewModel = ConcertViewModel(concert: hotConcerts[0])
    
    HotelsView(concertViewModel: concertViewModel)
}
