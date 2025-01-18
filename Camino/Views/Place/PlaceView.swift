import SwiftUI
import MapKit

struct PlaceView: View {
    
    var place: Place
    
    @StateObject var viewModel: PlaceViewModel
    
    init(place: Place) {
        self.place = place
        _viewModel = StateObject(wrappedValue: PlaceViewModel(place: place))
    }
    
    @State var hasAppeared: Bool = false
    @State private var isTitleVisible: Bool = true
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                switch viewModel.placeDetailsResponse.status {
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
                    ErrorView(text: "Error fetching destination details", action: {
                        await viewModel.getPlaceDetails()
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
                        await viewModel.getPlaceDetails()
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
            if let placeDetails = viewModel.placeDetailsResponse.data?.placeDetails {
                GeometryReader { geometry in
                    ZStack(alignment: .top) {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 0) {
                                TabView {
                                    ForEach(placeDetails.images, id: \.self) { imageUrl in
                                        ImageLoader(url: imageUrl, contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width, height: 300)
                                            .clipped()
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                                .frame(height: 300)
                                
                                VStack(spacing: 20) {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(placeDetails.name)
                                            .font(.system(size: 30, type: .SemiBold))
                                        
                                        Text(placeDetails.description)
                                            .font(.system(size: 16, type: .Regular))
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
                                        ForEach((LineItemType.placeItems(placeViewModel: viewModel)), id: \.title) { item in
                                            switch item {
                                            case .flights:
                                                LineItem(item: item, price: viewModel.flightsPrice, status: viewModel.flightsResponse.status)
                                            case .hotel:
                                                LineItem(item: item, price: viewModel.hotelsPrice, status: viewModel.hotelsResponse.status)
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
                                    
                                    VStack(spacing: 10) {
                                        if placeDetails.concerts.isEmpty {
                                            Text("No Upcoming Concerts")
                                                .font(.system(size: 20, type: .Medium))
                                                .frame(maxWidth: .infinity, alignment: .center)
                                                .padding(.vertical, 20)
                                        } else {
                                            Text("Upcoming Concerts")
                                                .font(.system(size: 23, type: .SemiBold))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            ForEach(placeDetails.concerts) { concert in
                                                NavigationLink{
                                                    ConcertView(concert: concert)
                                                        .navigationBarHidden(true)
                                                } label: {
                                                    ConcertRow(concert: concert, screen: "destination")
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                    }
                                    
                                    MapCard(addressToSearch: "\(placeDetails.cityName), \(placeDetails.countryName)", latitude: placeDetails.latitude, longitude: placeDetails.longitude, name: placeDetails.cityName, generalLocation: placeDetails.countryName)
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
                        }
                        .ignoresSafeArea(edges: .top)
                        .onScrollGeometryChange(for: CGFloat.self) { geo in
                            return geo.contentOffset.y
                        } action: { oldValue, newValue in                            
                            // Threshold for toggling title visibility
                            let threshold = 300 - 50 + 15 + 10 - geometry.safeAreaInsets.top
                            
                            withAnimation(.linear(duration: 0.3)) {
                                if newValue > threshold && isTitleVisible {
                                    isTitleVisible = false // Hide title
                                } else if newValue <= threshold && !isTitleVisible {
                                    isTitleVisible = true // Show title
                                }
                            }
                        }
                        
                        GeneralHeader(title: place.name)
                            .opacity(isTitleVisible ? 0 : 1)
                            .animation(.linear(duration: 0.1), value: isTitleVisible)
//                            .padding(.top, geometry.safeAreaInsets.top)
                    }
                }
            }
            else {
                ErrorView(text: "Error fetching place details", action: {
                    await viewModel.getPlaceDetails()
                })
            }
        }
    }
    
    
    
    
}

#Preview {
    let testPlace = Place(
        name: "Seattle",
        description: "Known for its iconic Space Needle, vibrant coffee culture, and stunning natural surroundings.",
        imageUrl: "https://uploads.visitseattle.org/2024/02/26114037/VS_base.jpg",
        countryName: "United States"
    )
    
    NavigationStack {
        PlaceView(place: testPlace)
            .navigationBarHidden(true)
    }
}
