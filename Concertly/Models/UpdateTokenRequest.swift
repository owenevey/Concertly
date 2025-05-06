import Foundation

struct UpdateTokenRequest: Codable {
    let deviceId: String
    let pushNotificationToken: String?
    let isNotificationsEnabled: Bool?
}

