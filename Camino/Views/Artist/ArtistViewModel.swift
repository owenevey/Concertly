import Foundation
import SwiftUI
import CoreLocation

@MainActor
class ArtistViewModel: ObservableObject {
    var artistId: String
    
    @Published var artistDetailsResponse: ApiResponse<Artist> = ApiResponse<Artist>()
    @Published var nearbyConcerts: [Concert] = []
    @Published var isFollowing: Bool
    
    private let coreDataManager = CoreDataManager.shared
    
    let homeLat: Double
    let homeLong: Double
    
    init(artistID: String) {
        self.artistId = artistID
        
        self.homeLat = UserDefaults.standard.double(forKey: "Home Lat")
        self.homeLong = UserDefaults.standard.double(forKey: "Home Long")
        
        self.isFollowing = coreDataManager.isFollowingArtist(id: artistId)
        
        Task {
            await getArtistDetails()
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
        isFollowing = coreDataManager.isFollowingArtist(id: artistId)
    }
    
    func toggleArtistFollowing() {
        if isFollowing {
            coreDataManager.unSaveArtist(id: artistId, category: "following")
        } else {
            if let artist = artistDetailsResponse.data {
                coreDataManager.saveArtist(SuggestedArtist(name: artist.name, id: artist.id, imageUrl: artist.imageUrl), category: "following")
            }
        }
        
        isFollowing.toggle()
    }
}
