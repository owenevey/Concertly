import SwiftUI
import MapKit

struct DestinationView: View {
    
    var destination: Destination
    
    @StateObject var viewModel: DestinationViewModel
    
    init(destination: Destination) {
        self.destination = destination
        _viewModel = StateObject(wrappedValue: DestinationViewModel(destination: destination))
    }
    
    @State var hasAppeared: Bool = false
    @State private var isTitleVisible: Bool = true
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            TabView {
                                ForEach(destination.images, id: \.self) { imageUrl in
                                    ImageLoader(url: imageUrl, contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width, height: 300)
                                        .clipped()
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                            .frame(height: 300)
                            
                            VStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(destination.name)
                                        .font(.system(size: 30, type: .SemiBold))
                                    
                                    Text(destination.longDescription)
                                        .font(.system(size: 17, type: .Regular))
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
                                
                                
                                
                                MapCard(addressToSearch: "\(destination.cityName), \(destination.countryName)", latitude: destination.latitude, longitude: destination.longitude, name: destination.cityName, generalLocation: destination.countryName)
                                
                                CaminoButton(label: "Plan Trip") {
                                    print("Plan trip tapped")
                                }
                                .frame(width: UIScreen.main.bounds.width - 100)
                                
                            }
                            .padding(15)
                            .background(Color.background)
                            .frame(width: UIScreen.main.bounds.width)
                        }
                    }
                    .ignoresSafeArea(edges: .top)
                    .onScrollGeometryChange(for: CGFloat.self) { geo in
                        return geo.contentOffset.y
                    } action: { oldValue, newValue in
                        let threshold = 300 - 50 + 15 + 10 - geometry.safeAreaInsets.top
                        
                        withAnimation(.linear(duration: 0.3)) {
                            if newValue > threshold && isTitleVisible {
                                isTitleVisible = false
                            } else if newValue <= threshold && !isTitleVisible {
                                isTitleVisible = true
                            }
                        }
                    }
                    
                    GeneralHeader(title: destination.name)
                        .opacity(isTitleVisible ? 0 : 1)
                        .animation(.linear(duration: 0.1), value: isTitleVisible)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.background)
            .onAppear {
                if !hasAppeared {
                    Task {
                        await viewModel.getConcerts()
                        await viewModel.getDepartingFlights()
                        await viewModel.getHotels()
                    }
                    hasAppeared = true
                    let destinationUrls = destination.images.compactMap { return URL(string: $0) }
                    ImagePrefetcher.instance.startPrefetching(urls: destinationUrls)
                }
            }
            HStack {
                TranslucentBackButton()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    let lasVegas = Destination(
        name: "Las Vegas",
        shortDescription: "Known for its casinos, nightlife, shows, and extravagance",
        longDescription: "A dazzling desert oasis famous for its vibrant nightlife, world-class entertainment, luxurious resorts, and iconic casinos, offering an endless array of shows, dining, and nightlife options.",
        images: [
            "https://owenevey-camino.s3.us-east-1.amazonaws.com/destinationPhotos/lasVegas1.jpg",
            "https://owenevey-camino.s3.us-east-1.amazonaws.com/destinationPhotos/lasVegas2.jpg",
            "https://owenevey-camino.s3.us-east-1.amazonaws.com/destinationPhotos/lasVegas3.jpg",
            "https://owenevey-camino.s3.us-east-1.amazonaws.com/destinationPhotos/lasVegas4.jpg",
            "https://owenevey-camino.s3.us-east-1.amazonaws.com/destinationPhotos/lasVegas5.jpg"
        ],
        cityName: "Las Vegas, NV",
        countryName: "United States",
        latitude: 36.1716,
        longitude: -115.1391,
        geoHash: "9qqjgb"
    )
    
    NavigationStack {
        DestinationView(destination: lasVegas)
            .navigationBarHidden(true)
    }
}
