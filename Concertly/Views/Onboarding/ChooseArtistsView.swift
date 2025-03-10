import SwiftUI
import SmoothGradient

struct ChooseArtistsView: View {
        
    @AppStorage(AppStorageKeys.hasSeenOnboarding.rawValue) private var hasSeenOnboarding = false
    @FocusState private var isTextFieldFocused: Bool
    @State private var showHeaderBorder: Bool = false
    @State private var selectedArtists: Set<SuggestedArtist> = []
    
    private func onTapDone() async {
        hasSeenOnboarding = true
        for artist in selectedArtists {
            if !CoreDataManager.shared.isFollowingArtist(id: artist.id) {
                CoreDataManager.shared.saveArtist(SuggestedArtist(name: artist.name, id: artist.id, imageUrl: artist.imageUrl), category: ContentCategories.following.rawValue)
            }
            
            do {
                guard let pushNotificationToken = UserDefaults.standard.string(forKey: AppStorageKeys.pushNotificationToken.rawValue) else {
                    throw NSError(domain: "", code: 1, userInfo: nil)
                }
                
                let response = try await toggleFollowArtist(artistId: artist.id, pushNotificationToken: pushNotificationToken, follow: true)
                
                if response.status == .error {
                    throw NSError(domain: "", code: 1, userInfo: nil)
                }
            }
            catch {
                print("Error following the artist")
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
                    .frame(height: 1.5)
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
                    NavigationLink(destination: NotificationSelectionView(selectedArtists: selectedArtists)) {
                        Text("Next")
                            .font(.system(size: 17, type: .SemiBold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 60)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.accentColor)
                            )
                            .contentShape(RoundedRectangle(cornerRadius: 15))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .shadow(radius: 5)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
            
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


