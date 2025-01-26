import Foundation
import SwiftUI

@MainActor
class ArtistViewModel: ObservableObject {
    var artistId: String
    
    @Published var artistDetailsResponse: ApiResponse<Artist> = ApiResponse<Artist>()

    
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
}
