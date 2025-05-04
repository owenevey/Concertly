import Foundation
import SwiftUI

@MainActor
final class NearbyViewModel: ObservableObject {
    @Published var nearbyConcertsResponse: ApiResponse<[Concert]> = ApiResponse<[Concert]>()
    @Published var nearbyConcerts: [Concert] = []
        
    var homeLat: Double = 0.0
    var homeLong: Double = 0.0
    
    init() {
        let isSignedIn = UserDefaults.standard.bool(forKey: AppStorageKeys.isSignedIn.rawValue)

        if isSignedIn {
            let upcomingConcerts = CoreDataManager.shared.fetchItems(for: ContentCategories.nearby.rawValue, type: Concert.self, sortKey: "date")
            nearbyConcerts = upcomingConcerts.filter { $0.date >= Date() }
            self.homeLat = UserDefaults.standard.double(forKey: AppStorageKeys.homeLat.rawValue)
            self.homeLong = UserDefaults.standard.double(forKey: AppStorageKeys.homeLong.rawValue)
            
            Task {
                await getNearbyConcerts()
            }
        }
    }
    
    func getNearbyConcerts() async {
        self.homeLat = UserDefaults.standard.double(forKey: AppStorageKeys.homeLat.rawValue)
        self.homeLong = UserDefaults.standard.double(forKey: AppStorageKeys.homeLong.rawValue)
        
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
                CoreDataManager.shared.saveItems(concerts, category: ContentCategories.nearby.rawValue)
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
