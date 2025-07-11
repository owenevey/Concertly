import SwiftUI
import GoogleMobileAds

struct NearbyView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: NearbyViewModel
    
    @AppStorage(AppStorageKeys.homeCity.rawValue) private var homeCity: String = ""
    @AppStorage(AppStorageKeys.homeLat.rawValue) private var homeLat: Double = 0
    @AppStorage(AppStorageKeys.homeLong.rawValue) private var homeLong: Double = 0
    
    @State private var offset: CGFloat = 0
    @State private var isSearchBarVisible: Bool = true
    
    let adSize = currentOrientationAnchoredAdaptiveBanner(width: UIScreen.main.bounds.width - 40)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image(colorScheme == .light ? .nearbyBlobLight : .nearbyBlobDark)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: 250 + max(0, -offset - geometry.safeAreaInsets.top))
                    .scaledToFill()
                    .transformEffect(.init(translationX: 0, y: -max(0, offset + geometry.safeAreaInsets.top)))
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        VStack(spacing: 15) {
                            HStack(alignment: .top) {
                                VStack {
                                    HStack {
                                        Text("Concerts near")
                                            .font(.system(size: 17, type: .Regular))
                                        Image(systemName: "arrow.turn.right.down")
                                            .font(.system(size: 15))
                                            .padding(.top, 5)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(homeCity)
                                        .font(.system(size: 30, type: .Bold))
                                        .foregroundStyle(.accent)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                NavigationLink(value: "notifications") {
                                    Circle()
                                        .fill(Color.foreground)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "bell")
                                                .font(.system(size: 20))
                                                .fontWeight(.semibold)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .shadow(color: .black.opacity(0.1), radius: 5)
                            .padding(.horizontal, 15)
                            .frame(width: UIScreen.main.bounds.width)
                            
                            LazyVStack(spacing: 15) {
                                switch viewModel.nearbyConcertsResponse.status {
                                case .loading, .empty:
                                    if viewModel.nearbyConcerts.isEmpty {
                                        ForEach(0..<6, id: \.self) { _ in
                                            FallbackNearbyConcertCard()
                                        }
                                    } else {
                                        ForEach(viewModel.nearbyConcerts) { concert in
                                            NearbyConcertCard(concert: concert)
                                        }
                                    }
                                    
                                case .success:
                                    if viewModel.nearbyConcerts.isEmpty {
                                        VStack(spacing: 10) {
                                            Image(systemName: "music.note")
                                                .font(.system(size: 20))
                                                .fontWeight(.semibold)
                                            
                                            Text("No nearby concerts")
                                                .font(.system(size: 17, type: .Regular))
                                        }
                                        .frame(height: 250)
                                    } else {
                                        ForEach(Array(viewModel.nearbyConcerts.enumerated()), id: \.offset) { index, concert in
                                            NearbyConcertCard(concert: concert)
                                            
                                            if index != 0 && (index % 10) == 0 {
                                                BannerViewContainer(adSize, adUnitID: AdUnitIds.nearbyBanner.rawValue)
                                                    .frame(height: adSize.size.height)
                                                    .padding(.vertical, 5)
                                            }
                                        }
                                    }
                                    
                                case .error:
                                    if viewModel.nearbyConcerts.isEmpty {
                                        ForEach(0..<6, id: \.self) { _ in
                                            ErrorNearbyConcertCard()
                                        }
                                    } else {
                                        ForEach(viewModel.nearbyConcerts) { concert in
                                            NearbyConcertCard(concert: concert)
                                        }
                                    }
                                }
                            }
                            .shadow(color: .black.opacity(0.2), radius: 5)
                        }
                    }
                    Spacer()
                }
                .padding(.top, geometry.safeAreaInsets.top)
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    return geo.contentOffset.y
                } action: { oldValue, newValue in
                    offset = newValue
                    withAnimation(.linear(duration: 0.1)) {
                        if newValue + geometry.safeAreaInsets.top > 20 {
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
        .refreshable {
            Task {
                await viewModel.getNearbyConcerts()
            }
        }
        .onChange(of: homeCity) { checkAndFetch() }
    }
    
    private func checkAndFetch() {
        guard homeCity != "", homeLat != 0, homeLong != 0 else { return }
        Task { await viewModel.getNearbyConcerts() }
    }
}

#Preview {
    NavigationStack {
        NearbyView(viewModel: NearbyViewModel())
            .environmentObject(AnimationManager())
            .environmentObject(Router())
    }
}
