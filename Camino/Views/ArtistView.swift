import SwiftUI
import MapKit

struct ArtistView: View {
    
    var artistID: String
    
    @StateObject var viewModel: ArtistViewModel
    
    init(artistID: String) {
        self.artistID = artistID
        _viewModel = StateObject(wrappedValue: ArtistViewModel(artistID: artistID))
    }
    
    @State var hasAppeared: Bool = false
    
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
                    Spacer()
                    ErrorView(text: "Error fetching artist details", action: {
                        await viewModel.getArtistDetails()
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
                        await viewModel.getArtistDetails()
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
        if let artistDetails = viewModel.artistDetailsResponse.data?.artistDetails {
            ImageHeaderScrollView(imageUrl: artistDetails.imageUrl, showBackButton: false) {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(artistDetails.name)
                            .font(.system(size: 30, type: .SemiBold))
                        
                        Text(artistDetails.bio)
                            .font(.system(size: 16, type: .Regular))
                            .foregroundStyle(.gray3)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    //                    WrappingCollectionView(
                    //                        data: artistDetails.socials,
                    //                        spacing: 5,
                    //                        singleItemHeight: 43
                    //                    ) { social in
                    //                        HStack {
                    //                            Image(determineSocialImage(for: social))
                    //                                .resizable()
                    //                                .frame(width: 20, height: 20)
                    //                                .scaledToFit()
                    //
                    //                            if let url = URL(string: social.url) {
                    //                                Link(social.name, destination: url)
                    //                                    .font(.system(size: 16, type: .Medium))
                    //                                    .buttonStyle(PlainButtonStyle())
                    //                            }
                    //                        }
                    //                        .padding(.vertical, 10)
                    //                        .padding(.horizontal, 15)
                    //                        .background(
                    //                            Capsule(style: .continuous)
                    //                                .fill(Color.foreground)
                    //                                .stroke(.gray2, style: StrokeStyle(lineWidth: 1))
                    //                                .padding(1)
                    //                        )
                    //                        .frame(height: 43)
                    //                        .fixedSize(horizontal: true, vertical: true) // This is necessary for each item to be as tight as possible
                    //                    }
                    
                    
                    
                    //                    VStack(spacing: 10) {
                    //                        if artistDetails.concerts.isEmpty {
                    //                            Text("No Upcoming Concerts")
                    //                                .font(.system(size: 20, type: .Medium))
                    //                                .frame(maxWidth: .infinity, alignment: .center)
                    //                                .padding(.vertical, 20)
                    //                        } else {
                    //                            Text("Upcoming Concerts")
                    //                                .font(.system(size: 23, type: .SemiBold))
                    //                                .frame(maxWidth: .infinity, alignment: .leading)
                    //                            ForEach(artistDetails.concerts) { concert in
                    //                                NavigationLink{
                    //                                    ConcertView(concert: concert)
                    //                                        .navigationBarHidden(true)
                    //                                } label: {
                    //                                    ConcertRow(concert: concert)
                    //                                }
                    //                                .buttonStyle(PlainButtonStyle())
                    //                            }
                    //                        }
                    //                    }
                    
                    //                    VStack(spacing: 10) {
                    //                        if !artistDetails.similarArtists.isEmpty {
                    //                            Text("Similar Artists")
                    //                                .font(.system(size: 23, type: .SemiBold))
                    //                                .frame(maxWidth: .infinity, alignment: .leading)
                    //
                    //                            ScrollView(.horizontal, showsIndicators: false) {
                    //                                HStack(spacing: 15) {
                    //                                    ForEach(artistDetails.similarArtists) { artist in
                    //                                        NavigationLink{
                    //                                            ArtistView(artist: artist)
                    //                                                .navigationBarHidden(true)
                    //                                        } label: {
                    //                                            VStack {
                    //                                                AsyncImage(url: URL(string: artist.imageUrl)) { image in
                    //                                                    image
                    //                                                        .resizable()
                    //                                                } placeholder: {
                    //                                                    Color.foreground
                    //                                                }
                    //                                                .scaledToFill()
                    //                                                .frame(width: 100, height: 100)
                    //                                                .cornerRadius(50)
                    //                                                .clipped()
                    //
                    //                                                Text(artist.name)
                    //                                                    .font(.system(size: 18, type: .Medium))
                    //                                                    .frame(width: 100)
                    //                                                    .lineLimit(2, reservesSpace: true)
                    //                                                    .minimumScaleFactor(0.75)
                    //                                                    .multilineTextAlignment(.center)
                    //                                            }
                    //                                        }
                    //                                        .buttonStyle(PlainButtonStyle())
                    //                                    }
                    //                                }
                    //                                .padding(.horizontal, 15)
                    //                            }
                    //                            .padding(.horizontal, -15)
                    //                        }
                    //                    }
                }
                .padding(15)
                .containerRelativeFrame(.horizontal) { size, axis in
                    size
                }
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
            .navigationBarHidden(true)
    }
}


struct ConcertRow: View {
    
    var concert: Concert
    
    var body: some View {
        HStack(spacing: 15) {
            VStack {
                Text(concert.dateTime.dayNumber())
                    .font(.system(size: 23, type: .Medium))
                Text(concert.dateTime.shortMonthFormat())
                    .font(.system(size: 16, type: .Medium))
                    .foregroundStyle(.gray3)
            }
            .frame(width: 60, height: 60)
            .background(Color.background)
            .cornerRadius(10)
            
            VStack {
                Text(concert.cityName)
                    .font(.system(size: 18, type: .Medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                
                Text(concert.venueName)
                    .font(.system(size: 16, type: .Medium))
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 15))
                .fontWeight(.semibold)
                .padding(.trailing)
            
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(5)
        .background(Color.gray1)
        .cornerRadius(15)
    }
}
