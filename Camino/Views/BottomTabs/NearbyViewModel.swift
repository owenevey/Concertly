import Foundation
import SwiftUI

@MainActor
final class NearbyViewModel: ObservableObject {
    @Published var nearbyConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var nearbyConcerts: [Concert] = []
    
    func getNearbyConcerts() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.nearbyConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            let fetchedConcerts = try await fetchConcertsForDestination(lat: userLatitude, long: userLongitude)
            
            if let concerts = fetchedConcerts.data?.concerts {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.nearbyConcerts = concerts
                    self.nearbyConcertsResponse = ApiResponse(status: .success, data: concerts)
                }
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.nearbyConcertsResponse = ApiResponse(status: .error, error: "Couldn't fetch nearby concerts")
                }
            }
        } catch {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.nearbyConcertsResponse = ApiResponse(status: .error, error: error.localizedDescription)
            }
        }
    }

}
