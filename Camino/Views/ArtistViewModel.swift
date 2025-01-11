import Foundation
import SwiftUI

@MainActor
class ArtistViewModel: ObservableObject {
    var suggestedArtist: SuggestedArtist
    
    @Published var artistDetailsResponse: ApiResponse<ArtistDetailsResponse> = ApiResponse<ArtistDetailsResponse>()

    
    init(suggestedArtist: SuggestedArtist) {
        self.suggestedArtist = suggestedArtist
    }
    
    
    func getArtistDetails() async {
        self.artistDetailsResponse = ApiResponse(status: .loading)
        
        do {
            let fetchedDetails = try await fetchArtistDetails(artistId: suggestedArtist.id)
            
            withAnimation(.easeInOut) {
                self.artistDetailsResponse = ApiResponse(status: .success, data: fetchedDetails)
            }
            
        } catch {
            print("Error fetching artist details: \(error)")
            self.artistDetailsResponse = ApiResponse(status: .error, error: error.localizedDescription)
        }
    }
}
