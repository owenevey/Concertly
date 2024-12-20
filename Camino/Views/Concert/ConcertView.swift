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
        ImageHeaderScrollView(imageUrl: concert.imageUrl) {
            VStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(concert.name)
                        .font(.system(size: 30, type: .SemiBold))
                    
                    Text(concert.dateTime.formatted(date: .complete, time: .omitted))
                        .font(.system(size: 18, type: .Regular))
                        .foregroundStyle(.gray3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Minimum Price Summary")
                        .font(.system(size: 20, type: .SemiBold))
                    
                    Text("\(viewModel.tripStartDate.mediumFormat()) - \(viewModel.tripEndDate.mediumFormat())")
                        .font(.system(size: 16, type: .Regular))
                        .foregroundStyle(.gray3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack(spacing: 15) {
                    ForEach((LineItemType.allCases(concertViewModel: viewModel, link: concert.url)), id: \.title) { item in
                        switch item {
                        case .flights:
                            LineItem(item: item, price: viewModel.flightsPrice, status: viewModel.flightsResponse.status)
                        case .hotel:
                            LineItem(item: item, price: viewModel.hotelsPrice, status: viewModel.hotelsResponse.status)
                            
                        case .ticket:
                            LineItem(item: item, price: viewModel.ticketPrice, status: Status.success)
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
                            } else if viewModel.flightsResponse.status == .success && viewModel.hotelsResponse.status == .success {
                                Text("$\(viewModel.totalPrice)")
                                    .font(.system(size: 18, type: .Medium))
                            } else if viewModel.flightsResponse.status == .error || viewModel.hotelsResponse.status == .error {
                                Text("Error")
                                    .font(.system(size: 18, type: .Medium))
                            }
                        }
                        .transition(.opacity)
                        .animation(.easeInOut, value: viewModel.totalPrice)
                    }
                    .padding(.horizontal, 10)
                    
                }
                
                MapCard(address: concert.venueAddress, latitude: concert.latitude, longitude: concert.longitude, name: concert.venueName, generalLocation: concert.generalLocation)
                    .padding(.vertical, 10)
                
                Button {
                    print("Plan trip tapped")
                } label: {
                    Text("Plan Trip")
                        .font(.system(size: 18, type: .Medium))
                        .foregroundStyle(.white)
                        .padding(12)
                        .containerRelativeFrame(.horizontal) { size, axis in
                            size - 100
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.accent)
                        )
                    
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(15)
            .background(Color.background)
            
            .containerRelativeFrame(.horizontal) { size, axis in
                size
            }
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

