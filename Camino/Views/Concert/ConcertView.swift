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
                        .font(Font.custom("Barlow-Bold", size: 30))
                    
                    Text(concert.dateTime.formatted(date: .complete, time: .omitted))
                        .font(Font.custom("Barlow-SemiBold", size: 17))
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Minimum Price Summary")
                        .font(Font.custom("Barlow-SemiBold", size: 20))
                    
                    Text("\(viewModel.tripStartDate.mediumFormat()) - \(viewModel.tripEndDate.mediumFormat())")
                        .font(Font.custom("Barlow-SemiBold", size: 17))
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack(spacing: 15) {
                    ForEach((LineItemType.allCases(concertViewModel: viewModel, link: concert.url)), id: \.title) { item in
                        switch item {
                        case .flights:
                            LineItem(item: item, price: viewModel.flightsPrice)
                        case .hotel:
                            LineItem(item: item, price: viewModel.hotelPrice)
                            
                        case .ticket:
                            LineItem(item: item, price: viewModel.ticketPrice)
                        }
                    }
                    
                    Divider()
                        .frame(height: 2)
                        .overlay(.customGray)
                    
                    HStack {
                        Text("Total:")
                            .font(Font.custom("Barlow-SemiBold", size: 17))
                        Spacer()
                        Text("$\(viewModel.totalPrice)")
                            .font(Font.custom("Barlow-SemiBold", size: 17))
                    }
                    .padding(.horizontal, 10)
                    
                }
                
                MapCard(concert: concert)
                    .padding(.vertical, 10)
                
                Button {
                    print("Plan trip tapped")
                } label: {
                    Text("Plan Trip")
                        .font(Font.custom("Barlow-SemiBold", size: 18))
                        .padding()
                    
                        .containerRelativeFrame(.horizontal) { size, axis in
                            size - 100
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.accent)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(15)
            .background(Color("Background"))
            
            .containerRelativeFrame(.horizontal) { size, axis in
                size
            }
        }
        .background(Color("Background"))
        .ignoresSafeArea(edges: .top)
        .onAppear {
            if !hasAppeared {
                Task {
                    await viewModel.getDepartingFlights()
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

