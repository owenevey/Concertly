import Foundation
import SwiftUI
import CoreLocation

@MainActor
class ArtistViewModel: ObservableObject {
    var artistId: String
    
    @Published var artistDetailsResponse: ApiResponse<Artist> = ApiResponse<Artist>()
    @Published var nearbyConcerts: [Concert] = []
    @Published var isFollowing: Bool
    @Published var showError: Bool
    @Published var showSignInPrompt: Bool
        
    let homeLat: Double
    let homeLong: Double
    
    init(artistID: String) {
        self.artistId = artistID
        self.showError = false
        self.showSignInPrompt = false
        
        self.homeLat = UserDefaults.standard.double(forKey: AppStorageKeys.homeLat.rawValue)
        self.homeLong = UserDefaults.standard.double(forKey: AppStorageKeys.homeLong.rawValue)
        
        self.isFollowing = CoreDataManager.shared.isFollowingArtist(id: artistId)
        
        Task {
            await getArtistDetails()
            await FollowArtistTip.visitArtistEvent.donate()
        }
    }
    
    
    func getArtistDetails() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.artistDetailsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedDetails = try await fetchArtistDetails(id: artistId)
            
            if let artist = fetchedDetails.data?.artist {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.artistDetailsResponse = ApiResponse(status: .success, data: artist)
                    self.nearbyConcerts = filterNearbyConcerts(concerts: artist.concerts)
                }
                
                if isFollowing {
                    CoreDataManager.shared.unSaveArtist(id: artistId, category: ContentCategories.following.rawValue)
                    CoreDataManager.shared.saveArtist(SuggestedArtist(name: artist.name, id: artist.id, imageUrl: artist.cardImageUrl), category: ContentCategories.following.rawValue)
                }
                
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.artistDetailsResponse = ApiResponse(status: .error, error: "Couldn't fetch artist details")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.artistDetailsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
    
    func filterNearbyConcerts(concerts: [Concert]) -> [Concert] {
        let userLocation = CLLocation(latitude: homeLat, longitude: homeLong)
        
        return concerts.filter { concert in
            let concertLocation = CLLocation(latitude: concert.latitude, longitude: concert.longitude)
            let distanceInMeters = userLocation.distance(from: concertLocation)
            return distanceInMeters <= 50 * 1609.344 // 50 miles to meters
        }
    }
    
    func checkIfFollowing() {
        isFollowing = CoreDataManager.shared.isFollowingArtist(id: artistId)
    }
    
    func toggleArtistFollowing() async {
        let authStatus = UserDefaults.standard.string(forKey: AppStorageKeys.authStatus.rawValue)
        
        if authStatus == AuthStatus.guest.rawValue {
            showSignInPrompt = true
            return
        }
        
        let newTourDateNotifications = UserDefaults.standard.bool(forKey: AppStorageKeys.newTourDates.rawValue)

        if isFollowing {
            isFollowing = false
            CoreDataManager.shared.unSaveArtist(id: artistId, category: ContentCategories.following.rawValue)

            if newTourDateNotifications {
                do {
                    let response = try await toggleFollowArtist(artistId: artistId, follow: false)
                    
                    if response.status == .error {
                        throw NSError(domain: "", code: 1, userInfo: nil)
                    }
                }
                catch {
                    if let artist = artistDetailsResponse.data {
                        showError = true
                        isFollowing = true
                        CoreDataManager.shared.saveArtist(SuggestedArtist(name: artist.name, id: artist.id, imageUrl: artist.imageUrl), category: ContentCategories.following.rawValue)
                    }
                }
            }
        }
        else {
            isFollowing = true
            if let artist = artistDetailsResponse.data {
                CoreDataManager.shared.saveArtist(SuggestedArtist(name: artist.name, id: artist.id, imageUrl: artist.cardImageUrl), category: ContentCategories.following.rawValue)
            }
            
            Task {
                await FollowArtistTip.followArtistEvent.donate()
            }
            
            if newTourDateNotifications {
                do {
                    let response = try await toggleFollowArtist(artistId: artistId, follow: true)
                    
                    if response.status == .error {
                        throw NSError(domain: "", code: 1, userInfo: nil)
                    }
                }
                catch {
                    showError = true
                    isFollowing = false
                    CoreDataManager.shared.unSaveArtist(id: artistId, category: ContentCategories.following.rawValue)
                }
            }
        }
    }
}
