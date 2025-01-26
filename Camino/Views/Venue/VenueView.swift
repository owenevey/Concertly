import SwiftUI
import MapKit

struct VenueView: View {
    
    var venue: Venue
    
    @StateObject var viewModel: VenueViewModel
    
    init(venue: Venue) {
        self.venue = venue
        _viewModel = StateObject(wrappedValue: VenueViewModel(venue: venue))
    }
    
    @State var hasAppeared: Bool = false
    
    var body: some View {
        ImageHeaderScrollView(title: venue.name, imageUrl: venue.imageUrl) {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(venue.name)
                        .font(.system(size: 30, type: .SemiBold))
                    
                    Text(venue.description)
                        .font(.system(size: 16, type: .Regular))
                        .foregroundStyle(.gray3)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Price Summary")
                        .font(.system(size: 23, type: .SemiBold))
                    
                    Text("\(viewModel.tripStartDate.mediumFormat()) - \(viewModel.tripEndDate.mediumFormat())")
                        .font(.system(size: 17, type: .Regular))
                        .foregroundStyle(.gray3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack(spacing: 10) {
                    ForEach((LineItemType.destinationItems(destinationViewModel: viewModel)), id: \.title) { item in
                        switch item {
                        case .flights:
                            LineItem(item: item, status: viewModel.flightsResponse.status, price: viewModel.flightsPrice)
                        case .hotel:
                            LineItem(item: item, status: viewModel.hotelsResponse.status, price: viewModel.hotelsPrice)
                        default:
                            EmptyView()
                        }
                    }
                    
                    Divider()
                        .frame(height: 2)
                        .overlay(.gray2)
                    
                    HStack {
                        Text("Total:")
                            .font(.system(size: 18, type: .Medium))
                        
                        Spacer()
                        
                        Group {
                            if viewModel.flightsResponse.status == .loading || viewModel.hotelsResponse.status == .loading {
                                CircleLoadingView(ringSize: 20)
                                    .padding(.trailing, 10)
                            }
                            else if viewModel.flightsResponse.status == .success && viewModel.hotelsResponse.status == .success {
                                Text("$\(viewModel.totalPrice)")
                                    .font(.system(size: 18, type: .Medium))
                            }
                            else if viewModel.flightsResponse.status == .error || viewModel.hotelsResponse.status == .error {
                                Text("Error")
                                    .font(.system(size: 18, type: .Medium))
                            }
                        }
                        .transition(.opacity)
                        .animation(.easeInOut, value: viewModel.totalPrice)
                    }
                    .padding(.horizontal, 10)
                }
                
                switch viewModel.concertsResponse.status {
                case .empty, .loading:
                    LoadingView()
                        .frame(height: 150)
                case .success:
                    if let concerts = viewModel.concertsResponse.data {
                        VStack(spacing: 10) {
                            if concerts.isEmpty {
                                Text("No Upcoming Concerts")
                                    .font(.system(size: 23, type: .Medium))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 20)
                            } else {
                                Text("Upcoming Concerts")
                                    .font(.system(size: 23, type: .SemiBold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ForEach(concerts) { concert in
                                    NavigationLink{
                                        ConcertView(concert: concert)
                                            .navigationBarHidden(true)
                                    } label: {
                                        ConcertRow(concert: concert, screen: .destination)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                case .error:
                    ErrorView(text: "Error fetching concerts", action: viewModel.getConcerts)
                }
                
                MapCard(addressToSearch: venue.address, latitude: venue.latitude, longitude: venue.longitude, name: venue.cityName, generalLocation: venue.countryName)
                    .padding(.vertical, 10)

            }
            .padding(15)
            .containerRelativeFrame(.horizontal) { size, axis in
                size
            }
        }
        .background(Color.background)
        .onAppear {
            if !hasAppeared {
                Task {
                    await viewModel.getConcerts()
                    await viewModel.getDepartingFlights()
                    await viewModel.getHotels()
                }
                hasAppeared = true
            }
        }
    }
    
    
}

//#Preview {
//    NavigationStack {
//        VenueView(venueId: "KovZpZA7AAEA")
//            .navigationBarHidden(true)
//    }
//}
