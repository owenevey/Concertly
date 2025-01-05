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
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ZStack(alignment: .top) {
                        TabView {
                            ForEach(place.images, id: \.self) { imageUrl in
                                if let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Color.foreground
                                    }
                                    .frame(width: UIScreen.main.bounds.width)
                                    .frame(height: 300)
                                    .clipped()
                                    
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .frame(height: 300)
                        
                        HStack {
                            TranslucentBackButton()
                                .padding(.top, geometry.safeAreaInsets.top)
                            Spacer()
                        }
                    }
                    
                    VStack(spacing: 20) {
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(place.name)
                                .font(.system(size: 30, type: .SemiBold))
                            
                            Text(place.longDescription)
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
                        
                        MapCard(addressToSearch: "\(place.cityName), \(place.countryName)", latitude: place.latitude, longitude: place.longitude, name: place.cityName, generalLocation: place.countryName)
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
            .background(Color.background)
            .ignoresSafeArea(edges: .top)
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
        
        
        
        
        //        ImageHeaderScrollView(headerContent:
        //                                TabView {
        //            ForEach(place.images, id: \.self) { imageUrl in
        //                if let url = URL(string: imageUrl) {
        //                    AsyncImage(url: url) { image in
        //                        image
        //                            .resizable()
        //                            .scaledToFill()
        //                    } placeholder: {
        //                        Color.foreground
        //                    }
        //                    .frame(width: UIScreen.main.bounds.width)
        //                    .frame(minHeight: 300)
        //                    .clipped()
        //                    .scrollTargetLayout()
        //                    .border(.green, width: 3)
        //                }
        //            }
        //        }
        //            .border(.red, width: 1)
        //            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        //            ) {
        //                VStack(spacing: 20) {
        //
        //                    VStack(alignment: .leading, spacing: 5) {
        //                        Text(place.name)
        //                            .font(.system(size: 30, type: .SemiBold))
        //
        //                        Text(place.longDescription)
        //                            .font(.system(size: 16, type: .Regular))
        //                            .foregroundStyle(.gray3)
        //                    }
        //                    .frame(maxWidth: .infinity, alignment: .leading)
        //
        //
        //                    VStack(alignment: .leading, spacing: 5) {
        //                        Text("Minimum Price Summary")
        //                            .font(.system(size: 20, type: .SemiBold))
        //
        //                        Text("\(viewModel.tripStartDate.mediumFormat()) - \(viewModel.tripEndDate.mediumFormat())")
        //                            .font(.system(size: 16, type: .Regular))
        //                            .foregroundStyle(.gray3)
        //                    }
        //                    .frame(maxWidth: .infinity, alignment: .leading)
        //
        //
        //                    VStack(spacing: 15) {
        //                        ForEach((LineItemType.placeItems(placeViewModel: viewModel)), id: \.title) { item in
        //                            switch item {
        //                            case .flights:
        //                                LineItem(item: item, price: viewModel.flightsPrice, status: viewModel.flightsResponse.status)
        //                            case .hotel:
        //                                LineItem(item: item, price: viewModel.hotelsPrice, status: viewModel.hotelsResponse.status)
        //                            default:
        //                                EmptyView()
        //                            }
        //                        }
        //
        //                        Divider()
        //                            .frame(height: 2)
        //                            .overlay(.gray2)
        //
        //                        HStack {
        //                            Text("Total:")
        //                                .font(.system(size: 18, type: .Medium))
        //                            Spacer()
        //                            Group {
        //                                if viewModel.flightsResponse.status == .loading || viewModel.hotelsResponse.status == .loading {
        //                                    CircleLoadingView(ringSize: 20)
        //                                        .padding(.trailing, 10)
        //                                } else if viewModel.flightsResponse.status == .success && viewModel.hotelsResponse.status == .success {
        //                                    Text("$\(viewModel.totalPrice)")
        //                                        .font(.system(size: 18, type: .Medium))
        //                                } else if viewModel.flightsResponse.status == .error || viewModel.hotelsResponse.status == .error {
        //                                    Text("Error")
        //                                        .font(.system(size: 18, type: .Medium))
        //                                }
        //                            }
        //                            .transition(.opacity)
        //                            .animation(.easeInOut, value: viewModel.totalPrice)
        //                        }
        //                        .padding(.horizontal, 10)
        //
        //                    }
        //
        //                    MapCard(addressToSearch: "\(place.cityName), \(place.countryName)", latitude: place.latitude, longitude: place.longitude, name: place.cityName, generalLocation: place.countryName)
        //                        .padding(.vertical, 10)
        //
        //                    Button {
        //                        print("Plan trip tapped")
        //                    } label: {
        //                        Text("Plan Trip")
        //                            .font(.system(size: 18, type: .Medium))
        //                            .foregroundStyle(.white)
        //                            .padding(12)
        //                            .containerRelativeFrame(.horizontal) { size, axis in
        //                                size - 100
        //                            }
        //                            .clipShape(RoundedRectangle(cornerRadius: 15))
        //                            .background(
        //                                RoundedRectangle(cornerRadius: 15)
        //                                    .fill(.accent)
        //                            )
        //
        //                    }
        //                    .buttonStyle(PlainButtonStyle())
        //                }
        //                .padding(15)
        //                .background(Color.background)
        //
        //                .containerRelativeFrame(.horizontal) { size, axis in
        //                    size
        //                }
        //            }
        //            .background(Color.background)
        //            .onAppear {
        //                if !hasAppeared {
        //                    Task {
        //                        await viewModel.getDepartingFlights()
        //                        await viewModel.getHotels()
        //                    }
        //                    hasAppeared = true
        //                }
        //            }
    }
    
    
}

#Preview {
    let testPlace = Place(
        name: "Seattle",
        shortDescription: "Famous for the Space Needle and vibrant coffee culture.",
        longDescription: "Known for its iconic Space Needle, vibrant coffee culture, and stunning natural surroundings. With a booming tech industry and cultural attractions, it’s a city full of energy and creativity.",
        images: [
            "https://uploads.visitseattle.org/2024/02/26114037/VS_base.jpg",
            "https://harrell.seattle.gov/wp-content/uploads/sites/23/2023/12/DSC_3910-Edit-Edit.jpg"
        ],
        cityName: "Seattle, WA",
        countryName: "United States",
        latitude: 47.6062,
        longitude: -122.3321
    )
    
    NavigationStack {
        PlaceView(place: testPlace)
            .navigationBarHidden(true)
    }
}
