import Foundation
import SwiftUI

@MainActor
class ArtistViewModel: ObservableObject {
    var artistID: String
    
    @Published var artistDetailsResponse: ApiResponse<ArtistDetailsResponse> = ApiResponse<ArtistDetailsResponse>()

    
    init(artistID: String) {
        self.artistID = artistID
    }
    
    
    func getArtistDetails() async {
        self.artistDetailsResponse = ApiResponse(status: .loading)
        
        do {
            let fetchedDetails = try await fetchArtistDetails(artistId: artistID)
            
            withAnimation(.easeInOut(duration: 0.1)) {
                self.artistDetailsResponse = ApiResponse(status: .success, data: fetchedDetails)
            }
            
        } catch {
            print("Error fetching artist details: \(error)")
            self.artistDetailsResponse = ApiResponse(status: .error, error: error.localizedDescription)
        }
    }
}
