import Foundation
import SwiftUI

@MainActor
final class NotificationsViewModel: ObservableObject {
    @Published var notifications: [SavedNotification] = []
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        notifications = coreDataManager.fetchItems(type: SavedNotification.self)
    }
    
    func getNotifications() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.notifications = coreDataManager.fetchItems(type: SavedNotification.self)
        }
    }

}
