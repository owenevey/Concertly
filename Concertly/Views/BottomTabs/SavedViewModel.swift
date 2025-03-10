import Foundation
import SwiftUI

@MainActor
final class SavedViewModel: ObservableObject {
    @Published var savedConcerts: [Concert] = []
    
    init() {
        Task {
            await getSavedConcerts()
        }
    }
    
    func getSavedConcerts() async {
        let allConcerts = CoreDataManager.shared.fetchItems(for: ContentCategories.saved.rawValue, type: Concert.self)
        let upcomingConcerts = allConcerts.filter { $0.date >= Date() }
        withAnimation(.easeInOut(duration: 0.2)) {
            savedConcerts = upcomingConcerts
        }
        
        let pastConcerts = allConcerts.filter { $0.date < Date() }
        for concert in pastConcerts {
            CoreDataManager.shared.unSaveConcert(id: concert.id)
        }
    }
}
