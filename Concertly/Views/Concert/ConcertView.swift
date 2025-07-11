import SwiftUI
import StoreKit

struct ConcertView: View {
    
    var concert: Concert
    
    @StateObject var viewModel: ConcertViewModel
    
    @EnvironmentObject var router: Router
    @Environment(\.requestReview) private var requestReview
    
    @AppStorage(AppStorageKeys.concertViewCount.rawValue) var concertViewCount: Int = 0
    
    init(concert: Concert) {
        self.concert = concert
        _viewModel = StateObject(wrappedValue: ConcertViewModel(concert: concert))
    }
    
    var concertName: String {
        if viewModel.concert.names.count > 1 {
            return ""
        } else if viewModel.concert.names.count == 1 && (viewModel.concert.names[0].lowercased() != viewModel.concert.artistName.lowercased()) {
            return viewModel.concert.names[0]
        }
        return ""
    }
    
    var body: some View {
        ImageHeaderScrollView(title: viewModel.concert.artistName, imageUrl: viewModel.concert.imageUrl, rightIcon: "bookmark", rightIconFilled: viewModel.isSaved, onRightIconTap: viewModel.toggleConcertSaved) {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 5) {
                            Image(systemName: "calendar")
                                .frame(width: 22)
                            Text(viewModel.concert.date.fullWeekdayFormat(timeZoneIdentifier: viewModel.concert.timezone))
                                .font(.system(size: 18, type: .Regular))
                        }
                        .foregroundStyle(.gray3)
                        
                        HStack(spacing: 5) {
                            Image(systemName: "mappin.and.ellipse")
                                .frame(width: 22)
                            Text(viewModel.concert.cityName)
                                .font(.system(size: 18, type: .Regular))
                        }
                        .foregroundStyle(.gray3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if concertName != "" {
                        HStack(alignment: .top, spacing: 5) {
                            Image(systemName: "music.microphone")
                                .padding(.top, 2)
                                .frame(width: 22)
                            Text(concertName)
                                .font(.system(size: 18, type: .Regular))
                        }
                        .foregroundStyle(.gray3)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Price Summary")
                            .font(.system(size: 23, type: .SemiBold))
                        
                        Text("\(viewModel.tripStartDate.mediumFormat()) - \(viewModel.tripEndDate.mediumFormat())")
                            .font(.system(size: 17, type: .Regular))
                            .foregroundStyle(.gray3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 10) {
                        let pairedArray = zip(viewModel.concert.names, viewModel.concert.urls).map { ($0, $1) }
                        ForEach((LineItemType.concertItems(concertViewModel: viewModel, links: pairedArray)), id: \.title) { item in
                            switch item {
                            case .flights:
                                LineItem(item: item, status: viewModel.flightsResponse.status, price: viewModel.flightsPrice)
                            case .hotel:
                                LineItem(item: item, status: viewModel.hotelsResponse.status, price: viewModel.hotelsPrice)
                                
                            case .ticket:
                                LineItem(item: item, status: Status.success)
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
                }
                
                VStack(spacing: 10) {
                    Text("Lineup")
                        .font(.system(size: 23, type: .SemiBold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(viewModel.concert.lineup.prefix(3)) { artist in
                        LineupArtistRow(artist: artist)
                    }
                    
                    if viewModel.concert.lineup.count > 3 {
                        HStack {
                            NavigationLink(value: viewModel.concert.lineup) {
                                HStack(spacing: 5) {
                                    Text("View all \(viewModel.concert.lineup.count) artists")
                                        .font(.system(size: 18, type: .Regular))
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .padding(.top, 2)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }
                    }
                }
                
                VStack(spacing: 5) {
                    Text("Event Details")
                        .font(.system(size: 23, type: .SemiBold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 5) {
                        Image(systemName: "clock")
                            .frame(width: 22)
                        Text(viewModel.concert.date.timeFormatAMPM(timeZoneIdentifier: viewModel.concert.timezone))
                            .font(.system(size: 18, type: .Regular))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.gray3)
                    
                    HStack(spacing: 5) {
                        Image(systemName: "building.2")
                            .frame(width: 22)
                        Text(viewModel.concert.venueName)
                            .font(.system(size: 18, type: .Regular))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.gray3)
                    .padding(.bottom, 5)
                    
                    MapCard(addressToSearch: "\(viewModel.concert.venueName), \(viewModel.concert.venueAddress)", latitude: viewModel.concert.latitude, longitude: viewModel.concert.longitude, delta: 0.01)
                }
            }
            .padding([.horizontal, .bottom], 15)
            .padding(.top, 10)
        }
        .background(Color.background)
        .navigationBarHidden(true)
        .onAppear {
            concertViewCount += 1
            
            if concertViewCount > 30 && concertViewCount % 10 == 0 {
                Task {
                    try await Task.sleep(for: .seconds(2))
                    requestReview()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ConcertView(concert: hotConcerts[0])
            .environmentObject(Router())
    }
}

