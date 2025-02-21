import Foundation
import SwiftUI

@MainActor
final class NearbyViewModel: ObservableObject {
    @Published var nearbyConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var nearbyConcerts: [Concert] = []
    
    private let coreDataManager = CoreDataManager.shared
    
    var homeLat: Double
    var homeLong: Double
    
    init() {
        nearbyConcerts = coreDataManager.fetchItems(for: "nearby", type: Concert.self, sortKey: "date")
        self.homeLat = UserDefaults.standard.double(forKey: "Home Lat")
        self.homeLong = UserDefaults.standard.double(forKey: "Home Long")
        
        Task {
            await getNearbyConcerts()
        }
    }
    
    func getNearbyConcerts() async {
        self.homeLat = UserDefaults.standard.double(forKey: "Home Lat")
        self.homeLong = UserDefaults.standard.double(forKey: "Home Long")
        
        withAnimation(.easeInOut(duration: 0.2)) {
            self.nearbyConcertsResponse = ApiResponse(status: .loading)
        }
        
        do {
            let fetchedConcerts = try await fetchConcertsForDestination(lat: homeLat, long: homeLong)
            
            if let concerts = fetchedConcerts.data?.concerts {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.nearbyConcerts = concerts
                    self.nearbyConcertsResponse = ApiResponse(status: .success, data: concerts)
                }
                coreDataManager.saveItems(concerts, category: "nearby")
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
