import SwiftUI
import UserNotifications
import GoogleMobileAds
import Firebase
import FirebaseCore
import AWSCore
import AWSCognitoIdentityProvider

class CustomAppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    var app: ConcertlyApp?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        MobileAds.shared.start(completionHandler: nil)
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        
        let serviceConfig = AWSServiceConfiguration(
            region: .USEast1,
            credentialsProvider: nil
        )
        
        let poolConfig = AWSCognitoIdentityUserPoolConfiguration(
            clientId: getSecret("COGNITO_CLIENT_ID"),
            clientSecret: nil,
            poolId: getSecret("COGNITO_POOL_ID")
        )
        
        AWSCognitoIdentityUserPool.register(
            with: serviceConfig,
            userPoolConfiguration: poolConfig,
            forKey: "UserPool"
        )
                
        NotificationManager.shared.refreshNotificationPermissions()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Task {
            let newToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
            
            let storedToken = UserDefaults.standard.string(forKey: AppStorageKeys.pushNotificationToken.rawValue)
            
            if newToken != storedToken {
                UserDefaults.standard.set(newToken, forKey: AppStorageKeys.pushNotificationToken.rawValue)
                
                let authStatus = UserDefaults.standard.string(forKey: AppStorageKeys.authStatus.rawValue)
                
                if authStatus != AuthStatus.loggedOut.rawValue {
                    do {
                        let newTourDates = UserDefaults.standard.bool(forKey: AppStorageKeys.newTourDates.rawValue)
                        let response = try await updateDeviceToken(deviceId: DeviceIdManager.getDeviceId(), pushNotificationToken: newToken, isNotificationsEnabled: newTourDates)
                        
                        if response.status == .error {
                            throw NSError(domain: "", code: 0, userInfo: nil)
                        }
                    } catch {
                        print("Failed to update device token: \(error)")
                    }
                }
            }
        }
    }
}

extension CustomAppDelegate: UNUserNotificationCenterDelegate {
    // This function lets us do something when the user interacts with a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        if let aps = userInfo["aps"] as? [String: Any] {
            if let deepLink = aps["deepLink"] as? String, let url = URL(string: deepLink) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url)
                }
            }
            
            saveNotification(data: aps)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        if let aps = userInfo["aps"] as? [String: Any] {
            saveNotification(data: aps)
        }
        
        // Show banner, badge, and play sound
        completionHandler([.banner, .sound, .badge])
    }
    
    private func saveNotification(data: [String: Any]) {
        guard
            let dateString = data["date"] as? String,
            let date = ISO8601DateFormatter().date(from: dateString),
            let artistName = data["artistName"] as? String,
            let deepLink = data["deepLink"] as? String
        else {
            return
        }
        
        let type: String
        if deepLink.contains("artist") {
            type = "artist"
        } else if deepLink.contains("saved") {
            type = "saved"
        } else {
            return
        }
        
        let notification = SavedNotification(
            type: type,
            artistName: artistName,
            deepLink: deepLink,
            date: date
        )
        
        CoreDataManager.shared.saveItems([notification])
    }
}

