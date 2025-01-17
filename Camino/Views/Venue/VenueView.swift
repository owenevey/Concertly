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
                        
                        
                        
//                        VStack(spacing: 10) {
//                            if artistDetails.concerts.isEmpty {
//                                Text("No Upcoming Concerts")
//                                    .font(.system(size: 20, type: .Medium))
//                                    .frame(maxWidth: .infinity, alignment: .center)
//                                    .padding(.vertical, 20)
//                            } else {
//                                Text("Upcoming Concerts")
//                                    .font(.system(size: 23, type: .SemiBold))
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                ForEach(artistDetails.concerts) { concert in
//                                    NavigationLink{
//                                        ConcertView(concert: concert)
//                                            .navigationBarHidden(true)
//                                    } label: {
//                                        ConcertRow(concert: concert)
//                                    }
//                                    .buttonStyle(PlainButtonStyle())
//                                }
//                            }
//                        }

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
        ArtistView(artistID: "K8vZ9171r37")
            .navigationBarHidden(true)
    }
}


//struct ConcertRow: View {
//    
//    var concert: Concert
//    
//    var body: some View {
//        HStack(spacing: 15) {
//            VStack {
//                Text(concert.dateTime.dayNumber())
//                    .font(.system(size: 23, type: .Medium))
//                Text(concert.dateTime.shortMonthFormat())
//                    .font(.system(size: 16, type: .Medium))
//                    .foregroundStyle(.gray3)
//            }
//            .frame(width: 60, height: 60)
//            .background(Color.background)
//            .cornerRadius(10)
//            
//            VStack {
//                Text(concert.cityName)
//                    .font(.system(size: 18, type: .Medium))
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .lineLimit(1)
//                    .minimumScaleFactor(0.75)
//                
//                Text(concert.venueName)
//                    .font(.system(size: 16, type: .Medium))
//                    .foregroundStyle(.gray)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .lineLimit(1)
//                    .minimumScaleFactor(0.9)
//            }
//            
//            Image(systemName: "chevron.right")
//                .font(.system(size: 15))
//                .fontWeight(.semibold)
//                .padding(.trailing)
//            
//            
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding(5)
//        .background(Color.gray1)
//        .cornerRadius(15)
//    }
//}
