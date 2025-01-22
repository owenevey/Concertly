import SwiftUI
import MapKit

struct ConcertView: View {
    
    var concert: Concert
    
    @StateObject var viewModel: ConcertViewModel
    
    init(concert: Concert) {
        self.concert = concert
        _viewModel = StateObject(wrappedValue: ConcertViewModel(concert: concert))
    }
    
    @State var hasAppeared: Bool = false
    
    var body: some View {
        ImageHeaderScrollView(title: concert.artistName, imageUrl: concert.imageUrl) {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .top) {
                        Text(concert.artistName)
                            .font(.system(size: 30, type: .SemiBold))
                        
                        Spacer()
                        
                        Menu {
                            NavigationLink {
                                ArtistView(artistID: concert.artistId)
                                    .navigationBarHidden(true)
                            } label: {
                                Label("View Artist", systemImage: "person.fill")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    if concert.name.lowercased() != concert.artistName.lowercased() {
                        Text(concert.name)
                            .font(.system(size: 18, type: .Regular))
                            .foregroundStyle(.gray3)
                    }
                    
                    Text(concert.date.formatted(date: .complete, time: .omitted) + ", " + concert.date.timeFormatAMPM())
                        .font(.system(size: 18, type: .Regular))
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
                    ForEach((LineItemType.concertItems(concertViewModel: viewModel, link: concert.url)), id: \.title) { item in
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
                
                MapCard(addressToSearch: concert.venueAddress, latitude: concert.latitude, longitude: concert.longitude, name: concert.venueName, generalLocation: concert.cityName)
                
                CaminoButton(label: "Plan Trip") {
                    print("Plan trip tapped")
                }
                .frame(width: UIScreen.main.bounds.width - 100)
            }
            .padding(15)
        }
        .background(Color.background)
        .onAppear {
            if !hasAppeared {
                Task {
                    await viewModel.getDepartingFlights()
                    await viewModel.getHotels()
                }
                hasAppeared = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        ConcertView(concert: hotConcerts[0])
            .navigationBarHidden(true)
    }
}

