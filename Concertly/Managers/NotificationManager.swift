import Foundation
import UserNotifications
import UIKit

class NotificationManager {
    static let shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {}
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        let authStatus = UserDefaults.standard.string(forKey: AppStorageKeys.authStatus.rawValue)
        
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Notification permission error: \(error)")
                }
                if granted && authStatus == AuthStatus.registered.rawValue {
                    UserDefaults.standard.set(true, forKey: AppStorageKeys.newTourDates.rawValue)
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
    
    func updateNewTourDateNotifications() async -> Bool {
        let newTourDateNotifications = UserDefaults.standard.bool(forKey: AppStorageKeys.newTourDates.rawValue)
        
        do {
            let response = try await updateDeviceToken(deviceId: DeviceIdManager.getDeviceId(), isNotificationsEnabled: newTourDateNotifications)
            
            if response.status == .error {
                throw NSError(domain: "updateDeviceToken API call failed", code: 1, userInfo: nil)
            }
        }
        catch {
            UserDefaults.standard.set(!newTourDateNotifications, forKey: AppStorageKeys.newTourDates.rawValue)
            return false
        }
        
        return true
    }
    
    func refreshNotificationPermissions() {
        let isPushNotificationsAuthorized = UserDefaults.standard.bool(forKey: AppStorageKeys.isPushNotificationsAuthorized.rawValue)
        let authStatus = UserDefaults.standard.string(forKey: AppStorageKeys.authStatus.rawValue)
        
        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                if !isPushNotificationsAuthorized {
                    UserDefaults.standard.set(true, forKey: AppStorageKeys.isPushNotificationsAuthorized.rawValue)
                    DispatchQueue.main.async {
                        if authStatus == AuthStatus.registered.rawValue {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            } else {
                if isPushNotificationsAuthorized {
                    UserDefaults.standard.set(false, forKey: AppStorageKeys.isPushNotificationsAuthorized.rawValue)
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

