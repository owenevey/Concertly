import Foundation

enum concertRemindersEnum: Int {
    case dayBefore = 1
    case weekBefore = 7
    case off = 0
}

enum AppStorageKeys: String {
    case hasSeenOnboarding
    case pushNotificationToken
    case homeCity
    case homeLat
    case homeLong
    case homeAirport
}
