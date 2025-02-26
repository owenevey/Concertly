import SwiftUI
import MapKit

struct ConcertView: View {
    
    var concert: Concert
    
    @StateObject var viewModel: ConcertViewModel
    
    init(concert: Concert) {
        self.concert = concert
        _viewModel = StateObject(wrappedValue: ConcertViewModel(concert: concert))
    }
    
    @State var hasAppeared = false
    
    var concertName: String {
        if concert.name.count > 1 {
            return ""
        } else if concert.name.count == 1 && (concert.name[0].lowercased() != concert.artistName.lowercased()) {
            return concert.name[0]
        }
        return ""
    }
    
    var body: some View {
        ImageHeaderScrollView(title: concert.artistName, imageUrl: concert.imageUrl) {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(spacing: 5) {
                                Image(systemName: "calendar")
                                    .frame(width: 22)
                                Text(concert.date.fullWeekdayFormat(timeZoneIdentifier: concert.timezone))
                                    .font(.system(size: 18, type: .Regular))
                            }
                            .foregroundStyle(.gray3)
                            
                            HStack(spacing: 5) {
                                Image(systemName: "mappin.and.ellipse")
                                    .frame(width: 22)
                                Text(concert.cityName)
                                    .font(.system(size: 18, type: .Regular))
                            }
                            .foregroundStyle(.gray3)
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.toggleConcertSaved()
                        } label: {
                            Image(systemName: viewModel.isSaved ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 23))
                                .fontWeight(.medium)
                                .padding(.top, 5)
                                .foregroundStyle(Color.primary)
                        }
                    }
                    
                    
                    
                    if concertName != "" {
                        HStack(alignment: .top, spacing: 5) {
                            Image(systemName: "music.microphone")
                                .padding(.top, 3)
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
                        let pairedArray = zip(concert.name, concert.url).map { ($0, $1) }
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
                    
                    ForEach(concert.lineup.prefix(3)) { artist in
                        LineupArtistRow(artist: artist)
                    }
                    
                    if concert.lineup.count > 3 {
                        HStack {
                            NavigationLink {
                                FullLineupView(lineup: concert.lineup)
                            } label: {
                                HStack(spacing: 5) {
                                    Text("View all \(concert.lineup.count) artists")
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
                        Text(concert.date.timeFormatAMPM(timeZoneIdentifier: concert.timezone))
                            .font(.system(size: 18, type: .Regular))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.gray3)
                    
                    HStack(spacing: 5) {
                        Image(systemName: "building.2")
                            .frame(width: 22)
                        Text(concert.venueName)
                            .font(.system(size: 18, type: .Regular))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.gray3)
                    .padding(.bottom, 5)
                    
                    MapCard(addressToSearch: "\(concert.venueName), \(concert.venueAddress)", latitude: concert.latitude, longitude: concert.longitude, delta: 0.01)
                }
            }
            .padding([.horizontal, .bottom], 15)
            .padding(.top, 10)
        }
        .background(Color.background)
        .onAppear {
            viewModel.checkIfSaved()
            
            if !hasAppeared {
                Task {
                    await viewModel.getDepartingFlights()
                    await viewModel.getHotels()
                }
                hasAppeared = true
            }
        }
        .navigationBarHidden(true)
    }
    
    
}

#Preview {
    NavigationStack {
        ConcertView(concert: hotConcerts[0])
    }
}

