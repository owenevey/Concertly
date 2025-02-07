import Foundation
import SwiftUI

@MainActor
final class SavedViewModel: ObservableObject {
    @Published var savedConcerts: [Concert] = []
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        savedConcerts = coreDataManager.fetchItems(for: "saved", type: Concert.self)
    }
    
    func getSavedConcerts() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.savedConcerts = coreDataManager.fetchItems(for: "saved", type: Concert.self)
        }
    }

}
