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
    
    @State private var selectedHotel: Property? = nil
    
    var body: some View {
        HidingHeaderView (
            header: {
                HotelsHeader(fromDate: $viewModel.fromDate, toDate: $viewModel.toDate, location: $viewModel.location)
            },
            filtersBar: {
                HotelsFilterBar(sortMethod: $viewModel.sortMethod, priceFilter: $viewModel.priceFilter, hotelPrices: viewModel.hotelPrices, ratingFilter: $viewModel.ratingFilter, locationRatingFilter: $viewModel.locationRatingFilter)
            },
            scrollContent: {
                mainContent
            }
        )
        .onChange(of: viewModel.location, { handleLocationChange() })
        .onChange(of: viewModel.selectedHotel, { handleSelectedHotelChange() })
        .onChange(of: viewModel.fromDate, { handleDateChange() })
        .onChange(of: viewModel.toDate, { handleDateChange() })
        
        .sheet(isPresented: Binding<Bool>(
            get: { selectedHotel != nil },
            set: { isPresented in
                if !isPresented {
                    selectedHotel = nil
                }
            }
        )) {
            if let hotel = selectedHotel {
                HotelDetailsView(
                    property: hotel,
                    generalLocation: viewModel.location,
                    selectedHotel: $viewModel.selectedHotel
                )
                .presentationDetents([.large])
                .presentationBackground(Color.background)
            }
        }
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
                            .onTapGesture {
                                selectedHotel = property
                            }
                    }
                    .transition(.opacity)
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
    
    private func handleSelectedHotelChange() {
        concertViewModel.hotelsPrice = viewModel.selectedHotel?.totalRate.extractedLowest ?? 0
        dismiss()
    }
    
    private func refetchHotels() {
        Task {
            await viewModel.getHotels()
        }
        concertViewModel.hotelsResponse = viewModel.hotelsResponse
        concertViewModel.hotelsPrice = viewModel.hotelsResponse.data?.properties.first?.totalRate.extractedLowest ?? 0
    }
    
    private func handleLocationChange() {
        refetchHotels()
    }
    
    private func handleDateChange() {
        concertViewModel.tripStartDate = viewModel.fromDate
        concertViewModel.tripEndDate = viewModel.toDate
        refetchHotels()
        Task {
            await concertViewModel.getDepartingFlights()
        }
    }
}

#Preview {
    let concertViewModel = ConcertViewModel(concert: hotConcerts[0])
    
    HotelsView(concertViewModel: concertViewModel)
}
