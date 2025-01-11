import SwiftUI
import MapKit

struct ArtistView: View {
    
    var artist: SuggestedArtist
    
    @StateObject var viewModel: ArtistViewModel
    
    init(artist: SuggestedArtist) {
        self.artist = artist
        _viewModel = StateObject(wrappedValue: ArtistViewModel(suggestedArtist: artist))
    }
    
    @State var hasAppeared: Bool = false
    
    var body: some View {
        VStack {
            switch viewModel.artistDetailsResponse.status {
            case .empty:
                Spacer()
                LoadingView()
                    .frame(height: 250)
                    .transition(.opacity)
                Spacer()
            case .loading:
                Spacer()
                LoadingView()
                    .frame(height: 250)
                    .transition(.opacity)
                Spacer()
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
        
    }
    
    private var mainContent: some View {
        ImageHeaderScrollView(imageUrl: artist.imageUrl) {
            VStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(artist.name)
                        .font(.system(size: 30, type: .SemiBold))
                    
                    Text(viewModel.artistDetailsResponse.data!.artistDetails.bio)
                        .font(.system(size: 16, type: .Regular))
                        .foregroundStyle(.gray3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                //                ScrollView(.horizontal, showsIndicators: false) {
                //                    HStack {
                //                        HStack {
                //                            Image(.spotify)
                //                                .resizable()
                //                                .frame(width: 20, height: 20)
                //                                .scaledToFit()
                //
                //                            Text("Spotify")
                //                                .font(.system(size: 16, type: .Medium))
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
                //                    }
                //                }
                
//                WrappingCollectionView(
//                    data: viewModel.artistDetailsResponse.data!.artistDetails.socials,
//                    spacing: 10, // Spacing between items both horizontally and vertically
//                    singleItemHeight: 43 // Height for each item
//                ) { social in
//                    HStack {
//                        Image(.spotify)
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .scaledToFit()
//                        
//                        Text("Spotify")
//                            .font(.system(size: 16, type: .Medium))
//                    }
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 15)
//                    .background(
//                        Capsule(style: .continuous)
//                            .fill(Color.foreground)
//                            .stroke(.gray2, style: StrokeStyle(lineWidth: 1))
//                            .padding(1)
//                    )
////                    .frame(height: 43)
//                    
//                    .fixedSize(horizontal: true, vertical: true) // This is necessary for each item to be as tight as possible
//                }
                                
                
                VStack(spacing: 10) {
                    
                    Text("Upcoming Concerts")
                        .font(.system(size: 23, type: .SemiBold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let concerts = viewModel.artistDetailsResponse.data?.artistDetails.concerts {
                        ForEach(concerts) { concert in
                            NavigationLink{
                                ConcertView(concert: concert)
                                    .navigationBarHidden(true)
                            } label: {
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
                                        Text(concert.venueName)
                                            .font(.system(size: 16, type: .Medium))
                                            .foregroundStyle(.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
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
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                }
                
                VStack(spacing: 15) {
                    
                    if let similarArtists = viewModel.artistDetailsResponse.data?.artistDetails.similarArtists, !similarArtists.isEmpty {
                        Text("Similar Artists")
                            .font(.system(size: 23, type: .SemiBold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(similarArtists) { artist in
                                    
                                    NavigationLink{
                                        ArtistView(artist: artist)
                                            .navigationBarHidden(true)
                                    } label: {
                                        VStack {
                                            AsyncImage(url: URL(string: artist.imageUrl)) { image in
                                                image
                                                    .resizable()
                                            } placeholder: {
                                                Color.background
                                            }
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(50)
                                            .clipped()
                                            
                                            Text(artist.name)
                                                .font(.system(size: 18, type: .Medium))
                                                .frame(width: 100)
                                                .lineLimit(2, reservesSpace: true)
                                                .minimumScaleFactor(0.75)
                                                .multilineTextAlignment(.center)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 15)
                        }
                        .padding(.horizontal, -15)
                    }
                    
                }
            }
            .padding(15)
            .background(Color.background)
            
            .containerRelativeFrame(.horizontal) { size, axis in
                size
            }
        }
        .background(Color.background)
        
    }
    
    
}

#Preview {
    NavigationStack {
        ArtistView(artist: SuggestedArtist(name: "Train", id: "K8vZ9171r37", imageUrl: "https://s1.ticketm.net/dam/a/0c7/071342e9-852f-45ca-9916-dd306ab3c0c7_TABLET_LANDSCAPE_3_2.jpg"))
            .navigationBarHidden(true)
    }
}

