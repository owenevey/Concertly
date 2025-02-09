import SwiftUI

struct ProfileView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var profileViewModel: ProfileViewModel
    @StateObject var nearbyViewModel: NearbyViewModel
    
    @AppStorage("Home Airport") private var homeAirport: String = "JFK"
    @AppStorage("Theme") private var theme: String = "Default"
    @AppStorage("Home City") private var homeCity: String = "New York, NY"
    
    @State private var isSearchBarVisible: Bool = true
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 15) {
                        
                        HStack(alignment: .top) {
                            Text("Profile")
                                .font(.system(size: 30, type: .Bold))
                                .foregroundStyle(.accent)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .shadow(color: .black.opacity(0.1), radius: 5)
                        
                        VStack(spacing: 0) {
                            Text("Following")
                                .font(.system(size: 20, type: .SemiBold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(profileViewModel.followingArtists) { artist in
                                        ArtistCard(artist: artist)
                                    }
                                }
                                .shadow(color: .black.opacity(0.2), radius: 5)
                                .padding(.top, 10)
                                .padding(.bottom, 15)
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .safeAreaPadding(.horizontal, 15)
                            .padding(.horizontal, -15)
                        }
                        
                        VStack(spacing: 10) {
                            Text("Preferences")
                                .font(.system(size: 23, type: .SemiBold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(spacing: 0) {
                                
                                ProfileRow(imageName: "airplane.departure", name: "Home Airport", selection: homeAirport, destination: AirportSearchView(airportCode: $homeAirport, title: "Home Airport"))
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(.gray2)
                                    .padding(.horizontal, 15)
                                
                                ProfileRow(imageName: "building.2.fill", name: "Home City", selection: homeCity, destination: CitySearchView(location: $homeCity, title: "Home City"))
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(.gray2)
                                    .padding(.horizontal, 15)
                                
                                HStack {
                                    Image(systemName: "circle.lefthalf.filled")
                                        .frame(width: 22)
                                    Text("Theme")
                                        .font(.system(size: 17, type: .Regular))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Spacer()
                                    
                                    Menu {
                                        Button("Default") { theme = "Default" }
                                        Button("Light") { theme = "Light" }
                                        Button("Dark") { theme = "Dark" }
                                    } label: {
                                        Text(theme)
                                            .font(.system(size: 17, type: .Regular))
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 13))
                                            .fontWeight(.semibold)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 15)
                                .contentShape(Rectangle())
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray1)
                                    .frame(maxWidth: .infinity)
                            )
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    
                }
                .padding(.top, geometry.safeAreaInsets.top)
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    return geo.contentOffset.y
                } action: { oldValue, newValue in
                    withAnimation(.linear(duration: 0.1)) {
                        if newValue > -20 {
                            //change numbers
                            isSearchBarVisible = false
                        } else {
                            isSearchBarVisible = true
                        }
                    }
                }
                
                ExploreHeader()
                    .opacity(isSearchBarVisible ? 0 : 1)
                    .padding(.top, geometry.safeAreaInsets.top)
            }
            .ignoresSafeArea(edges: .top)
        }
        .background(Color.background)
        .onAppear {
            profileViewModel.getFollowingArtists()
        }
        .onChange(of: homeCity) {
            Task {
                await nearbyViewModel.getNearbyConcerts()
            }
        }
    }
    
    struct ProfileRow<Destination: View>: View {
        let imageName: String
        let name: String
        let selection: String
        let destination: Destination
        
        var body: some View {
            NavigationLink(destination: destination) {
                HStack {
                    Image(systemName: imageName)
                        .frame(width: 22)
                    Text(name)
                        .font(.system(size: 17, type: .Regular))
                    
                    Spacer()
                    
                    Text(selection)
                        .font(.system(size: 17, type: .Regular))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 15)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(profileViewModel: ProfileViewModel(), nearbyViewModel: NearbyViewModel())
    }
}
