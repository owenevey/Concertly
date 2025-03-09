import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {}
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Notification permission error: \(error)")
                }
                completion(granted)
            }
        }
    }
    
    func removeAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func scheduleConcertReminder(for concert: Concert, daysBefore: Int) {
        let calendar = Calendar.current
        guard let reminderDate = calendar.date(byAdding: .day, value: -daysBefore, to: concert.date) else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Concert Reminder"
        content.body = "\(concert.artistName) is coming up soon!"
        content.sound = .default
        content.userInfo = [
            "aps": [
                "artistName": concert.artistName,
                "deepLink": "concertly://saved/\(concert.id)",
                "date": reminderDate.ISO8601Format()
            ]
        ]
        
        let triggerDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: concert.id, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled for \(concert.name) on \(reminderDate)")
            }
        }
    }
    
    func updateAllConcertReminders() {
        removeAllNotifications()
        
        let concertRemindersPreference = UserDefaults.standard.integer(forKey: AppStorageKeys.concertReminders.rawValue)
        
        let concerts = CoreDataManager.shared.fetchItems(for: ContentCategories.saved.rawValue, type: Concert.self)
        
        if concertRemindersPreference != 0 {
            for concert in concerts {
                scheduleConcertReminder(for: concert, daysBefore: concertRemindersPreference)
            }
        }
    }
    
    func updateNewTourDateNotifications() async {
        do {
            let concertRemindersPreference = UserDefaults.standard.bool(forKey: AppStorageKeys.concertReminders.rawValue)
            
            guard let pushNotificationToken = UserDefaults.standard.string(forKey: AppStorageKeys.pushNotificationToken.rawValue) else {
                throw NSError(domain: "", code: 1, userInfo: nil)
            }
            
            let followedArtists = CoreDataManager.shared.fetchItems(for: "following", type: Artist.self)
            
            for artist in followedArtists {
                let response = try await toggleFollowArtist(artistId: artist.id, pushNotificationToken: pushNotificationToken, follow: concertRemindersPreference)
                
                if response.status == .error {
                    throw NSError(domain: "", code: 1, userInfo: nil)
                }
            }
        }
        catch {
            
        }
    }
}

struct SavedNotification: Identifiable {
    let type: String
    let artistName: String
    let deepLink: String
    let date: Date
    var id: String {
        "\(deepLink)-\(date.ISO8601Format())"
    }
}

