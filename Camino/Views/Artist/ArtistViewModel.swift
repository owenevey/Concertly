import Foundation
import SwiftUI

@MainActor
class ArtistViewModel: ObservableObject {
    var artistId: String
    
    @Published var artistDetailsResponse: ApiResponse<ArtistDetailsResponse> = ApiResponse<ArtistDetailsResponse>()

    
    init(artistID: String) {
        self.artistId = artistID
    }
    
    
    func getArtistDetails() async {
        withAnimation(.easeInOut(duration: 0.1)) {
            self.artistDetailsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedDetails = try await fetchArtistDetails(artistId: artistId)
            
            withAnimation(.easeInOut(duration: 0.1)) {
                self.artistDetailsResponse = ApiResponse(status: .success, data: fetchedDetails)
            }
            
        } catch {
            print("Error fetching artist details: \(error)")
            withAnimation(.easeInOut(duration: 0.1)) {
                self.artistDetailsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
}
