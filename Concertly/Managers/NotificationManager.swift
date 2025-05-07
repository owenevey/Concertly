import Foundation
import UserNotifications
import UIKit

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
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                completion(granted)
            }
        }
    }
    
    func removeAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func removeConcertReminder(for concert: Concert) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [concert.id])
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
                print("Notification scheduled for \(concert.names) on \(reminderDate)")
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
        let newTourDateNotifications = UserDefaults.standard.bool(forKey: AppStorageKeys.newTourDates.rawValue)
        
        do {
            let response = try await updateDeviceToken(deviceId: DeviceIdManager.getDeviceId(), isNotificationsEnabled: newTourDateNotifications)
            
            if response.status == .error {
                throw NSError(domain: "", code: 1, userInfo: nil)
            }
        }
        catch {
            // NEED TO DO SOMETHING HERE, show snackbar
            UserDefaults.standard.set(!newTourDateNotifications, forKey: AppStorageKeys.newTourDates.rawValue)
            print("error in updateNewTourDateNotifications")
        }
    }
    
    func refreshNotificationPermissions() {
        let isPushNotificationsOn = UserDefaults.standard.bool(forKey: AppStorageKeys.isPushNotificationsOn.rawValue)
        
        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                if !isPushNotificationsOn {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        UserDefaults.standard.set(true, forKey: AppStorageKeys.isPushNotificationsOn.rawValue)
                    }
                }
            } else {
                if isPushNotificationsOn {
                    UserDefaults.standard.set(false, forKey: AppStorageKeys.isPushNotificationsOn.rawValue)
                }
            }
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

