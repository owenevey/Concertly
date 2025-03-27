import SwiftUI
import UserNotifications
import GoogleMobileAds
import Firebase
import FirebaseCore

class CustomAppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    var app: ConcertlyApp?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        MobileAds.shared.start(completionHandler: nil)
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let stringifiedToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.standard.set(stringifiedToken, forKey: AppStorageKeys.pushNotificationToken.rawValue)
    }
}

extension CustomAppDelegate: UNUserNotificationCenterDelegate {
    // This function lets us do something when the user interacts with a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        if let aps = userInfo["aps"] as? [String: String] {
            saveNotification(data: aps)
            
            if let deepLink = aps["deepLink"], let url = URL(string: deepLink) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    private func saveNotification(data: [String: String]) {
        var type = ""
        var date = Date()
        var artistName = ""
        var deepLink = ""

        if let dateString = data["date"], let dateObject = ISO8601DateFormatter().date(from: dateString) {
            date = dateObject
        } else {
            return
        }

        if let unwrappedArtistName = data["artistName"] {
            artistName = unwrappedArtistName
        } else {
            return
        }
        
        if let unwrappedDeepLink = data["deepLink"] {
            deepLink = unwrappedDeepLink
        } else {
            return
        }
        
        if deepLink.contains("artist") {
            type = "artist"
        } else if deepLink.contains("saved") {
            type = "saved"
        } else {
            return
        }

        let notification = SavedNotification(type: type, artistName: artistName, deepLink: deepLink, date: date)
        
        CoreDataManager.shared.saveItems([notification])
    }
    
    // This function allows us to view notifications in the app even with it in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        // These options are the options that will be used when displaying a notification with the app in the foreground
        // for example, we will be able to display a badge on the app a banner alert will appear and we could play a sound
        return [.badge, .banner, .list, .sound]
    }
    
    
}

