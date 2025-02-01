import Foundation
import SwiftUI
import CoreLocation

@MainActor
class ArtistViewModel: ObservableObject {
    var artistId: String
    
    @Published var artistDetailsResponse: ApiResponse<Artist> = ApiResponse<Artist>()
    @Published var nearbyConcerts: [Concert] = []
    
    init(artistID: String) {
        self.artistId = artistID
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
        let userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
        
        return concerts.filter { concert in
            let concertLocation = CLLocation(latitude: concert.latitude, longitude: concert.longitude)
            let distanceInMeters = userLocation.distance(from: concertLocation)
            return distanceInMeters <= 50 * 1609.344 // 50 miles to meters
        }
    }
}
