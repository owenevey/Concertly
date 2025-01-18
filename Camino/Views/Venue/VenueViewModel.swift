import Foundation
import SwiftUI

@MainActor
class VenueViewModel: ObservableObject {
    var venueId: String
    
    @Published var venueDetailsResponse: ApiResponse<VenueDetailsResponse> = ApiResponse<VenueDetailsResponse>()

    
    init(venueId: String) {
        self.venueId = venueId
    }
    
    
    func getVenueDetails() async {
        self.venueDetailsResponse = ApiResponse(status: .loading)
        
        do {
            let fetchedDetails = try await fetchVenueDetails(venueId: venueId)
            
            withAnimation(.easeInOut(duration: 0.1)) {
                self.venueDetailsResponse = ApiResponse(status: .success, data: fetchedDetails)
            }
            
        } catch {
            print("Error fetching venue details: \(error)")
            withAnimation(.easeInOut(duration: 0.1)) {
                self.venueDetailsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }
}
