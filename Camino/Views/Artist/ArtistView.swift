import SwiftUI
import CoreLocation

struct ArtistView: View {
    
    var artistID: String
    
    @StateObject var viewModel: ArtistViewModel
    
    init(artistID: String) {
        self.artistID = artistID
        _viewModel = StateObject(wrappedValue: ArtistViewModel(artistID: artistID))
    }
    
    @State var hasAppeared: Bool = false
    
    let userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
    
    private var nearbyConcerts: [Concert] {
        guard let artistDetails = viewModel.artistDetailsResponse.data else { return [] }
        return artistDetails.concerts.filter { concert in
            let concertLocation = CLLocation(latitude: concert.latitude, longitude: concert.longitude)
            let distanceInMeters = userLocation.distance(from: concertLocation)
            return distanceInMeters <= 50 * 1609.344 // 50 miles to meters
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                switch viewModel.artistDetailsResponse.status {
                case .loading, .empty:
                    VStack {
                        Spacer()
                        LoadingView()
                            .frame(height: 250)
                            .transition(.opacity)
                        Spacer()
                    }
                    
                case .error:
                    VStack {
                        Spacer()
                        ErrorView(text: "Error fetching artist details", action: {
                            await viewModel.getArtistDetails()
                        })
                        .frame(height: 250)
                        .transition(.opacity)
                        Spacer()
                    }
                    
                case .success:
                    mainContent
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.background)
            .onAppear {
                if !hasAppeared {
                    Task {
                        await viewModel.getArtistDetails()
                    }
                    hasAppeared = true
                }
            }
            HStack {
                BackButton(showBackground: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationBarHidden(true)
    }
    
    private var mainContent: some View {
        Group {
            if let artistDetails = viewModel.artistDetailsResponse.data {
                ImageHeaderScrollView(title: artistDetails.name, imageUrl: artistDetails.imageUrl, showBackButton: false) {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(alignment: .top) {
                                Text(artistDetails.name)
                                    .font(.system(size: 30, type: .SemiBold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Button(action: {
                                    print("Follow tapped")
                                }) {
                                    Text("Follow")
                                        .font(.system(size: 16, type: .Medium))
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.gray1)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            Text(artistDetails.description)
                                .font(.system(size: 17, type: .Regular))
                                .foregroundStyle(.gray3)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if !artistDetails.socials.isEmpty {
                            WrappingCollectionView(
                                data: artistDetails.socials,
                                spacing: 5,
                                singleItemHeight: 43
                            ) { social in
                                
                                HStack {
                                    if let url = URL(string: social.url) {
                                        Link(destination: url) {
                                            HStack {
                                                Image(determineSocialImage(for: social))
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .scaledToFit()
                                                
                                                Text(social.name)
                                                    .font(.system(size: 16, type: .Medium))
                                                    .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 15)
                                .background(
                                    Capsule(style: .continuous)
                                        .fill(Color.foreground)
                                        .stroke(.gray2, style: StrokeStyle(lineWidth: 1))
                                        .padding(1)
                                )
                                .frame(height: 43)
                                .fixedSize(horizontal: true, vertical: true) // This is necessary for each item to be as tight as possible
                            }
                            .padding(.top, -10)
                        }
                        
                        if !artistDetails.concerts.isEmpty {
                        VStack(spacing: 10) {
                            if nearbyConcerts.isEmpty {
                                Text("No Nearby Concerts")
                                    .font(.system(size: 23, type: .Medium))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 5)
                            } else {
                                Text("Nearby Concerts")
                                    .font(.system(size: 23, type: .SemiBold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ForEach(nearbyConcerts) { concert in
                                    NavigationLink{
                                        ConcertView(concert: concert)
                                    } label: {
                                        ConcertRow(concert: concert, screen: .artist)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                        
                        VStack(spacing: 10) {
                            if artistDetails.concerts.isEmpty {
                                Text("No Upcoming Concerts")
                                    .font(.system(size: 23, type: .Medium))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 5)
                            } else {
                                Text("Upcoming Concerts")
                                    .font(.system(size: 23, type: .SemiBold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ForEach(artistDetails.concerts) { concert in
                                    NavigationLink{
                                        ConcertView(concert: concert)
                                    } label: {
                                        ConcertRow(concert: concert, screen: .artist)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        
                        if !artistDetails.similarArtists.isEmpty {
                            VStack(spacing: 10) {
                                Text("Similar Artists")
                                    .font(.system(size: 23, type: .SemiBold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(artistDetails.similarArtists) { artist in
                                            NavigationLink{
                                                ArtistView(artistID: artist.id)
                                            } label: {
                                                VStack {
                                                    ImageLoader(url: artist.imageUrl, contentMode: .fill)
                                                        .frame(width: 90, height: 90)
                                                        .cornerRadius(45)
                                                        .clipped()
                                                    
                                                    Text(artist.name)
                                                        .font(.system(size: 18, type: .Medium))
                                                        .frame(width: 100)
                                                        .lineLimit(2, reservesSpace: true)
                                                        .minimumScaleFactor(0.9)
                                                        .multilineTextAlignment(.center)
                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .scrollTargetLayout()
                                }
                                .scrollTargetBehavior(.viewAligned)
                                .safeAreaPadding(.horizontal, 15)
                                .padding(.horizontal, -15)
                            }
                        }
                    }
                    .padding(15)
                }
                .background(Color.background)
            } else {
                ErrorView(text: "Error fetching artist details", action: {
                    await viewModel.getArtistDetails()
                })
            }
        }
    }
    
    
}

#Preview {
    NavigationStack {
        ArtistView(artistID: "K8vZ9171r37")
    }
}



