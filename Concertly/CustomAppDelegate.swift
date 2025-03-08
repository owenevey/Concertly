import SwiftUI
import UserNotifications

class CustomAppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    // This gives us access to the methods from our main app code inside the app delegate
    var app: ConcertlyApp?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let stringifiedToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.standard.set(stringifiedToken, forKey: "pushNotificationToken")
    }
}

extension CustomAppDelegate: UNUserNotificationCenterDelegate {
    // This function lets us do something when the user interacts with a notification
    // like log that they clicked it, or navigate to a specific screen
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        if let aps = userInfo["aps"] as? [String: String] {
            storeNotification(data: aps)
            
            if let deepLink = aps["deepLink"], let url = URL(string: deepLink) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    private func storeNotification(data: [String: String]) {
        var type = ""
        var date = Date()
        var artistName = ""
        var deepLink = ""

        if let dateString = data["date"], let dateObject = ISO8601DateFormatter().date(from: dateString) {
            date = dateObject
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

