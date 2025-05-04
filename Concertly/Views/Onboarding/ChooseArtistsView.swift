import SwiftUI
import SmoothGradient

struct ChooseArtistsView: View {
    
    @AppStorage(AppStorageKeys.hasFinishedOnboarding.rawValue) private var hasFinishedOnboarding = false
    @AppStorage(AppStorageKeys.homeCity.rawValue) private var homeCity = ""
    @AppStorage(AppStorageKeys.homeLat.rawValue) private var homeLat: Double = 0
    @AppStorage(AppStorageKeys.homeLong.rawValue) private var homeLong: Double = 0
    @AppStorage(AppStorageKeys.homeAirport.rawValue) private var homeAirport = ""
    
    @FocusState private var isTextFieldFocused: Bool
    @State private var showHeaderBorder: Bool = false
    @State private var selectedArtists: Set<SuggestedArtist> = []
        
    @State var savePreferencesResponse: ApiResponse<String> = ApiResponse<String>()
    @State var showError = false
    
    
    private func onTapDone() async {
        let followedArtists: [FollowedArtist] = selectedArtists.map { suggestedArtist in
            FollowedArtist(id: suggestedArtist.id, name: suggestedArtist.name)
        }
        
        let userPreferencesRequest = UserPreferencesRequest(artists: followedArtists, follow: true, city: homeCity, latitude: homeLat, longitude: homeLong, airport: homeAirport)
        
        withAnimation(.easeInOut(duration: 0.2)) {
            savePreferencesResponse = ApiResponse(status: .loading)
        }
        
        do {
            let response = try await updateUserPreferences(request: userPreferencesRequest)
            
            if response.status == .error {
                throw NSError(domain: "", code: 1, userInfo: nil)
            }
            
            withAnimation(.easeInOut(duration: 0.2)) {
                savePreferencesResponse = ApiResponse(status: .success)
            }
            
            hasFinishedOnboarding = true
            
            for artist in selectedArtists {
                CoreDataManager.shared.saveArtist(artist, category: ContentCategories.following.rawValue)
            }
            
        } catch {
            print(error)
            withAnimation(.easeInOut(duration: 0.2)) {
                savePreferencesResponse = ApiResponse(status: .error, error: error.localizedDescription)
                showError = true
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("Select your favorite artsts")
                        .font(.system(size: 23, type: .SemiBold))
                        .foregroundStyle(.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("We'll suggest concerts based on your preferences")
                        .font(.system(size: 16, type: .Regular))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 5)
                .padding(.bottom, 10)
                
                Divider()
                    .frame(height: 1)
                    .overlay(.gray2)
                    .opacity(showHeaderBorder ? 1 : 0)
                    .animation(.linear(duration: 0.1), value: showHeaderBorder)
                    .padding(.horizontal, -10)
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                        ForEach(onboardingArtists, id: \.id) { artist in
                            Button {
                                toggleSelection(for: artist)
                            } label: {
                                OnboardingArtistCard(artist: artist, isSelected: selectedArtists.contains(artist))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.bottom, 15)
                }
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    return geo.contentOffset.y
                } action: { oldValue, newValue in
                    withAnimation(.linear(duration: 0.3)) {
                        showHeaderBorder = newValue > 0
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    ConcertlyButton(label: "               Next               ", fitText: true) {
                        await onTapDone()
                    }
                    .shadow(radius: 5)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
            
            
            
            SnackbarView(show: $showError, message: "Sorry, an error occurred. Please try again.")
                .opacity(showError ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: showError)
            
        }
        .background(Color.background)
        .navigationBarHidden(true)
        .disableSwipeBack(true)
    }
    
    private func toggleSelection(for artist: SuggestedArtist) {
        withAnimation(.linear(duration: 0.1)) {
            if selectedArtists.contains(artist) {
                selectedArtists.remove(artist)
            } else {
                selectedArtists.insert(artist)
            }
        }
    }
    
    private struct OnboardingArtistCard: View {
        
        var artist: SuggestedArtist
        var isSelected: Bool
        
        var body: some View {
            if let image = artist.localImageName {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(width: (UIScreen.main.bounds.width - 30)/2, height: 200)
                    .clipped()
                    .contentShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        ZStack(alignment: .bottom) {
                            SmoothLinearGradient(
                                from: .clear,
                                to: .black.opacity(0.8),
                                startPoint: .top,
                                endPoint: .bottom,
                                curve: .easeInOut)
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                            
                            VStack {
                                Text(artist.name)
                                    .font(.system(size: 23, type: .SemiBold))
                                    .foregroundStyle(.white)
                                    .minimumScaleFactor(0.9)
                                    .lineLimit(2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 15)
                                    .padding(.bottom, 10)
                            }
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(isSelected ? .accent : Color.clear, lineWidth: 5)
                            
                            VStack {
                                Image(systemName: "checkmark.circle")
                                    .foregroundStyle(.accent)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .shadow(radius: 5)
                                    .padding(15)
                                    .opacity(isSelected ? 1 : 0)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChooseArtistsView()
    }
}


