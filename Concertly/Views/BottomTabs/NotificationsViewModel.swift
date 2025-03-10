import Foundation
import SwiftUI

@MainActor
final class NotificationsViewModel: ObservableObject {
    @Published var notifications: [SavedNotification] = []
        
    init() {
        notifications = CoreDataManager.shared.fetchItems(type: SavedNotification.self)
    }
    
    func getNotifications() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            self.notifications = CoreDataManager.shared.fetchItems(type: SavedNotification.self)
        }
    }

}
