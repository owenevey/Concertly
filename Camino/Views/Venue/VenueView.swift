import SwiftUI
import MapKit

struct VenueView: View {
    
    var venueId: String
    
    @StateObject var viewModel: VenueViewModel
    
    init(venueId: String) {
        self.venueId = venueId
        _viewModel = StateObject(wrappedValue: VenueViewModel(venueId: venueId))
    }
    
    @State var hasAppeared: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                switch viewModel.venueDetailsResponse.status {
                case .loading, .empty:
                    VStack {
                        Spacer()
                        LoadingView()
                            .frame(height: 250)
                            .transition(.opacity)
                        Spacer()
                    }
                case .error:
                    Spacer()
                    ErrorView(text: "Error fetching venue details", action: {
                        await viewModel.getVenueDetails()
                    })
                    .frame(height: 250)
                    .transition(.opacity)
                    Spacer()
                case .success:
                    mainContent
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.background)
            .onAppear {
                if !hasAppeared {
                    Task {
                        await viewModel.getVenueDetails()
                    }
                    hasAppeared = true
                }
            }
            HStack {
                TranslucentBackButton()
                Spacer()
            }
        }
    }
    
    private var mainContent: some View {
        Group {
            if let venueDetails = viewModel.venueDetailsResponse.data?.venue {
                ImageHeaderScrollView(title: venueDetails.name, imageUrl: venueDetails.imageUrl, showBackButton: false) {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(venueDetails.name)
                                .font(.system(size: 30, type: .SemiBold))
                            
                            Text(venueDetails.description)
                                .font(.system(size: 16, type: .Regular))
                                .foregroundStyle(.gray3)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        
                        VStack(spacing: 10) {
                            if venueDetails.concerts.isEmpty {
                                Text("No Upcoming Concerts")
                                    .font(.system(size: 20, type: .Medium))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 20)
                            } else {
                                Text("Upcoming Concerts")
                                    .font(.system(size: 23, type: .SemiBold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                ForEach(venueDetails.concerts) { concert in
                                    NavigationLink{
                                        ConcertView(concert: concert)
                                            .navigationBarHidden(true)
                                    } label: {
                                        ConcertRow(concert: concert, screen: "venue")
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        MapCard(addressToSearch: venueDetails.address, latitude: venueDetails.latitude, longitude: venueDetails.longitude, name: venueDetails.cityName, generalLocation: venueDetails.countryName)
                            .padding(.vertical, 10)

                    }
                    .padding(15)
                    .containerRelativeFrame(.horizontal) { size, axis in
                        size
                    }
                }
                .background(Color.background)
            } else {
                ErrorView(text: "Error fetching artist details", action: {
                    await viewModel.getVenueDetails()
                })
            }
        }
    }
    
    
}

#Preview {
    NavigationStack {
        VenueView(venueId: "KovZpZA7AAEA")
            .navigationBarHidden(true)
    }
}
