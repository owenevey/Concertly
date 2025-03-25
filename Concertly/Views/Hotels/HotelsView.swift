import SwiftUI
import GoogleMobileAds

struct HotelsView<T: TripViewModelProtocol>: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var tripViewModel: T
    @StateObject var viewModel: HotelsViewModel<T>
    
    init(tripViewModel: T) {
        self.tripViewModel = tripViewModel
        
        _viewModel = StateObject(wrappedValue: HotelsViewModel(
            tripViewModel: tripViewModel,
            location: tripViewModel.cityName,
            fromDate: tripViewModel.tripStartDate,
            toDate: tripViewModel.tripEndDate,
            hotelsResponse: tripViewModel.hotelsResponse
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
        .onChange(of: viewModel.selectedHotel, { handleSelectedHotelChange() })
        
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
                    selectedHotel: $viewModel.selectedHotel,
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
        VStack {
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
                            .fontWeight(.semibold)
                        
                        Text("No hotels")
                            .font(.system(size: 17, type: .Regular))
                    }
                    .frame(height: 250)
                    .transition(.opacity)
                } else {
                    LazyVStack(spacing: 15) {
                        ForEach(Array(viewModel.filteredHotels.enumerated()), id: \.offset) { index, property in
                            HotelCard(property: property)
                                .shadow(color: .black.opacity(0.05), radius: 5)
                                .transition(.opacity)
                                .onTapGesture {
                                    selectedHotel = property
                                }
                            
                            if index != 0 && (index % 7) == 0 {
                                BannerViewContainer(adSize, adUnitID: AdUnitIds.hotelsBanner.rawValue)
                                    .frame(height: adSize.size.height)
                                    .padding(.vertical, 5)
                            }
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
        tripViewModel.hotelsPrice = viewModel.selectedHotel?.totalRate?.extractedLowest ?? -1
        dismiss()
    }
}

#Preview {
    NavigationStack {
        ConcertView(concert: hotConcerts[0])
    }
}
